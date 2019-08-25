//
//  Server.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import CoreBluetooth
import Combine
import Serializable

public class Server: NSObject {
    // MARK: - UUIDS
    private static let transferServiceUUID = CBUUID(string: "FD792B42-90F7-4D24-9E8D-096D6EFBC31C")
    private static let transferServerboundCharacteristicUUID = CBUUID(string: "289698F1-1AB5-4315-915D-F8F0FE5F4EF0")
    private static let transferClientboundCharacteristicUUID = CBUUID(string: "DCADFB92-3B54-4024-8F0E-8CCE686DD24D")
    private static let transferCharacteristicUUIDs = [Server.transferServerboundCharacteristicUUID, Server.transferClientboundCharacteristicUUID]
    
    // MARK: - Properties
    
    private var channels: [ChannelID: Channel] = [:]
    private var nextChannelID: ChannelID = 0
    private var registeredClientboundMessages: [Byte: ClientboundMessage.Type] = [:]
    private let peripheral: CBPeripheral
    private var clientboundCharacteristic: CBCharacteristic?
    private var serverboundCharacteristic: CBCharacteristic?
    
    public let isReady = CurrentValueSubject<Bool, Never>(false)
    
    internal init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        super.init()
        
        peripheral.delegate = self
        peripheral.discoverServices([Server.transferServiceUUID])
        
        registerClientboundMessage(message: CloseChannelClientbound.self)
        registerClientboundMessage(message: LoginResponse.self)
        registerClientboundMessage(message: ChannelDataClientbound.self)
    }
    
    private func registerClientboundMessage(message: ClientboundMessage.Type) {
        registeredClientboundMessages[message.id] = message
    }
    
    private func getNextChannelID() -> ChannelID {
        defer {
            nextChannelID += 1
        }
        return nextChannelID
    }
    
    // MARK: - Handle incomming data/errors/etc
    
    private func handleError(_ error: Error) {
        isReady.value = false
        
        channels.values.forEach { $0.clientbound.send(completion: .failure(.bluetoothError(error: error))) }
        channels = [:]
    }
    
    private func handleData(_ data: Data) {
        do {
            let buffer = ByteBuffer(elements: Array(data))
            let id = try Byte(from: buffer)

            guard let messageClass = registeredClientboundMessages[id] else {
                print("Unknown message id \(id)")
                return
            }

            let message = try messageClass.init(from: buffer)
            message.apply(to: self)

        } catch {
            print(error)
        }
    }
    
    // MARK: - Handle incomming messages
    
    internal func receivedData(_ data: Data, for channelID: ChannelID) {
        guard let channel = channels[channelID] else {
            print("Received data for unknown channel with id \(channelID)")
            return
        }
        
        channel.clientbound.send(data)
    }
    
    internal func channelClosedFromServer(channelID: ChannelID, error: String?) {
        guard let channel = channels.removeValue(forKey: channelID) else {
            print("Tried to close unknown channel with id \(channelID)")
            return
        }
        
        if let error = error {
            channel.clientbound.send(completion: .failure(.remoteClosed(message: error)))
        } else {
            channel.clientbound.send(completion: .finished)
        }
    }
    
    internal func handleLoginResponse(loginSucceeded: Bool) {
        isReady.send(loginSucceeded)
    }
    
    // MARK: - Outgoing messages
    
    private func sendMessage(_ message: ServerboundMessage) {
        guard let serverboundCharacteristic = serverboundCharacteristic else { return }
        
        let data = Data(message.directSerialized())
        peripheral.writeValue(data, for: serverboundCharacteristic, type: .withResponse)
    }
    
    private func openConnection() {
        // TODO: get correct sharedsecret
        sendMessage(OpenConnection(sharedSecret: "sharedsecret"))
    }
    
    public func openChannel(to module: String) -> Channel {
        let channelID = getNextChannelID()
        
        let channel = Channel(server: self, channelID: channelID)
        channels[channelID] = channel
        sendMessage(OpenChannel(channelID: channelID, moduleID: module))
        
        return channel
    }
    
    internal func sendData(_ data: Data, to channelID: ChannelID) {
        sendMessage(ChannelDataServerbound(channelID: channelID, data: data))
    }
    
    internal func closeChannel(withChannelID channelID: ChannelID) {
        sendMessage(CloseChannelServerbound(channelID: channelID))
        channels.removeValue(forKey: channelID)
    }
}

extension Server: CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            handleError(error)
            return
        }
        
        peripheral.services?.forEach {
            peripheral.discoverCharacteristics(Server.transferCharacteristicUUIDs, for: $0)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            handleError(error)
            return
        }
        
        service.characteristics?.forEach {
            switch $0.uuid {
            case Server.transferClientboundCharacteristicUUID:
                peripheral.setNotifyValue(true, for: $0)
                clientboundCharacteristic = $0
            case Server.transferServerboundCharacteristicUUID:
                serverboundCharacteristic = $0
            default:
                break
            }
        }
        
        if clientboundCharacteristic != nil && serverboundCharacteristic != nil {
            openConnection()
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            handleError(error)
            return
        }
        
        guard let data = characteristic.value else {
            return
        }
        
        handleData(data)
    }
}
