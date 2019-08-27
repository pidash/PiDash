//
//  ChannelDataServerbound.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct ChannelDataServerbound: ServerboundMessage {
    internal static var id: Byte = 2

    private let channelID: ChannelID
    private let data: Data

    internal init(channelID: ChannelID, data: Data) {
        self.channelID = channelID
        self.data = data
    }

    internal func serializeBody<Buffer: ByteWriteBuffer>(to buffer: Buffer) {
        channelID.serialize(to: buffer)
        data.serialize(to: buffer)
    }
}
