//
//  CloseChannelClientbound.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct CloseChannelClientbound: ClientboundMessage {
    internal static var id: Byte = 2

    private let channelID: ChannelID
    private let error: String?

    internal init<Buffer: ByteReadBuffer>(from buffer: Buffer) throws {
        channelID = try ChannelID(from: buffer)
        error = try String?(from: buffer)
    }

    internal func apply(to server: Server) {
        server.channelClosedFromServer(channelID: channelID, error: error)
    }
}
