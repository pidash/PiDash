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

    func serializeBody<Buffer>(to buffer: Buffer) where Buffer : ByteWriteBuffer
}

extension ServerboundMessage {
    internal func serialize<Buffer>(to buffer: Buffer) where Buffer : ByteWriteBuffer {
        Self.id.serialize(to: buffer)
        serializeBody(to: buffer)
    }
}

protocol TXMessageBodyless: ServerboundMessage {}

extension TXMessageBodyless {
    func serializeBody<Buffer>(to buffer: Buffer) where Buffer : ByteWriteBuffer {}
}
