//
//  OpenConnection.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct OpenConnection: ServerboundMessage {
    internal static var id: Byte = 0

    private let sharedSecret: String

    internal init(sharedSecret: String) {
        self.sharedSecret = sharedSecret
    }

    internal func serializeBody<Buffer: ByteWriteBuffer>(to buffer: Buffer) {
        sharedSecret.serialize(to: buffer)
    }
}
