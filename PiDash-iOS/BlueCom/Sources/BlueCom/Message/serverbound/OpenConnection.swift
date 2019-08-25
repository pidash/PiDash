//
//  OpenConnection.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct OpenConnection: ServerboundMessage {
    static var id: Byte = 0
    
    let sharedSecret: String
    
    func serializeBody<Buffer>(to buffer: Buffer) where Buffer : ByteWriteBuffer {
        sharedSecret.serialize(to: buffer)
    }
}
