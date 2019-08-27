//
//  OpenChannel.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct OpenChannel: ServerboundMessage {
    internal static var id: Byte = 1

    private let channelID: ChannelID
    private let moduleID: String

    internal init(channelID: ChannelID, moduleID: String) {
        self.channelID = channelID
        self.moduleID = moduleID
    }

    internal func serializeBody<Buffer: ByteWriteBuffer>(to buffer: Buffer) {
        channelID.serialize(to: buffer)
        moduleID.serialize(to: buffer)
    }
}
