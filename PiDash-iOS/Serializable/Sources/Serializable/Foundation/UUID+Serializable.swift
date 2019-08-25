//
//  UUID+Serializable.swift
//  PiDash
//
//  Created by Noah Peeters on 26.05.18.
//  Copyright © 2018 Noah Peeters. All rights reserved.
//

import Foundation

extension UUID: Serializable {
    public init<Buffer: ByteReadBuffer>(from buffer: Buffer) throws {
        var data = try buffer.read(lenght: 16)

        self = withUnsafePointer(to: &data[0]) {
            NSUUID(uuidBytes: $0) as UUID
        }
    }

    public func serialize<Buffer: ByteWriteBuffer>(to buffer: Buffer) {
        var uuid = self.uuid
        let data = withUnsafePointer(to: &uuid) {
            Data(bytes: $0, count: 16)
        }

        buffer.write(elements: Array(data))
    }
}
