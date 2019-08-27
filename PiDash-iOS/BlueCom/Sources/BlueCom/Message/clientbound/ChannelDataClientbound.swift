//
//  ChannelDataClientbound.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct ChannelDataClientbound: ClientboundMessage {
    internal static var id: Byte = 1

    private let channleID: ChannelID
    private let data: Data

    internal init<Buffer: ByteReadBuffer>(from buffer: Buffer) throws {
        try channleID = ChannelID(from: buffer)
        try data = Data(from: buffer)
    }

    internal func apply(to server: Server) {
        server.receivedData(data, for: channleID)
    }
}
