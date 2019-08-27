//
//  CloseChannelServerbound.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct CloseChannelServerbound: ServerboundMessage {
    static var id: Byte = 3
    
    let channelID: ChannelID
    
    func serializeBody<Buffer>(to buffer: Buffer) where Buffer : ByteWriteBuffer {
        channelID.serialize(to: buffer)
    }
}
