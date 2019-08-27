//
//  ServerboundMessage.swift
//  PiDash
//
//  Created by Noah Peeters on 10.02.19.
//  Copyright © 2019 Noah Peeters. All rights reserved.
//

import Foundation
import Serializable

internal protocol ServerboundMessage: SerializableDataType {
    static var id: Byte { get }

    func serializeBody<Buffer: ByteWriteBuffer>(to buffer: Buffer)
}

extension ServerboundMessage {
    internal func serialize<Buffer: ByteWriteBuffer>(to buffer: Buffer) {
        Self.id.serialize(to: buffer)
        serializeBody(to: buffer)
    }
}
