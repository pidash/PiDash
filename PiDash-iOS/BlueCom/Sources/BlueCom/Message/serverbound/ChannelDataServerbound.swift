//
//  ChannelDataServerbound.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct ChannelDataServerbound: ServerboundMessage {
    static var id: Byte = 2
    
    let channelID: ChannelID
    let data: Data
    
    func serializeBody<Buffer>(to buffer: Buffer) where Buffer : ByteWriteBuffer {
        channelID.serialize(to: buffer)
        data.serialize(to: buffer)
    }
}
