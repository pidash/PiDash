//
//  ServerManager.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import CoreBluetooth
import Combine

public class ServerManager: NSObject {
    private let centralManager = CBCentralManager()
    
    private var pendingPeripherals: Set<CBPeripheral> = []
    private var connectedPeripherals: Set<CBPeripheral> = []
    
    public let connectedServers = CurrentValueSubject<[Server], Never>([])
    
    public override init() {
        super.init()
        centralManager.delegate = self
    }
    
    private func startScanning() {
        guard centralManager.state == .poweredOn, !centralManager.isScanning else { return }

        self.centralManager.scanForPeripherals(
            withServices: [Server.transferServiceUUID],
            options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    private func stopScanning() {
        centralManager.stopScan()
    }
}

extension ServerManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScanning()
        default:
            stopScanning()
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard !pendingPeripherals.contains(peripheral) && !connectedPeripherals.contains(peripheral) else {
            return
        }
        centralManager.connect(peripheral, options: nil)
        pendingPeripherals.insert(peripheral)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let server = Server(peripheral: peripheral)
        connectedServers.value.append(server)
        connectedPeripherals.insert(peripheral)
        pendingPeripherals.remove(peripheral)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        guard let serverIndex = connectedServers.value.firstIndex(where: { $0.peripheral.identifier == peripheral.identifier }) else {
            print("Tried to disconnect from peripharal with unknown id \(peripheral.identifier)")
            return
        }
        
        let server = connectedServers.value.remove(at: serverIndex)
        server.handleDisconnect(error)
        connectedPeripherals.remove(peripheral)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        pendingPeripherals.remove(peripheral)
    }
}
