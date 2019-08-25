//
//  OpenChannel.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct OpenChannel: ServerboundMessage {
    static var id: Byte = 1
    
    let channelID: ChannelID
    let moduleID: String
    
    func serializeBody<Buffer>(to buffer: Buffer) where Buffer : ByteWriteBuffer {
        channelID.serialize(to: buffer)
        moduleID.serialize(to: buffer)
    }
}
