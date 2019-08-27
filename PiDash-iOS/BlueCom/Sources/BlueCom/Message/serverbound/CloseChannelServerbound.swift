//
//  CloseChannelServerbound.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct CloseChannelServerbound: ServerboundMessage {
    internal static var id: Byte = 3

    private let channelID: ChannelID

    internal init(channelID: ChannelID) {
        self.channelID = channelID
    }

    internal func serializeBody<Buffer: ByteWriteBuffer>(to buffer: Buffer) {
        channelID.serialize(to: buffer)
    }
}
