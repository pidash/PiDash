//
//  Channel.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Combine

typealias ChannelID = Int32

public class Channel {
    private let server: Server
    private let channelID: ChannelID
    
    public let clientbound = PassthroughSubject<Data, ChannelCloseError>()
    
    internal init(server: Server, channelID: ChannelID) {
        self.server = server
        self.channelID = channelID
    }
    
    public func closeChannel() {
        server.closeChannel(withChannelID: channelID)
    }
    
    public func sendData(_ data: Data) {
        server.sendData(data, to: channelID)
    }
}

public enum ChannelCloseError: Error {
    case remoteClosed(message: String)
    case bluetoothError(error: Error)
}
