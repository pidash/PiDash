//
//  Channel.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Combine
import Foundation

internal typealias ChannelID = Int32

/// Represents a channel between the server and the client.
public class Channel {
    private let server: Server
    private let channelID: ChannelID

    /// The datastream of all incomming data for this channel (e.g. send by the server).
    public let clientbound = PassthroughSubject<Data, ChannelCloseError>()

    internal init(server: Server, channelID: ChannelID) {
        self.server = server
        self.channelID = channelID
    }

    /// Closes the channel. No new data will be received after this call and the server channel will be informed.
    public func closeChannel() {
        server.closeChannel(withChannelID: channelID)
    }

    /// Send data to the server in this channel.
    /// - Parameter data: The data to send.
    public func sendData(_ data: Data) {
        server.sendData(data, to: channelID)
    }
}

public enum ChannelCloseError: Error {
    case remoteClosed(message: String)
    case bluetoothError(error: Error)
}
