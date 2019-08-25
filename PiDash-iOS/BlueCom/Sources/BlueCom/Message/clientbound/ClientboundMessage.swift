//
//  RXMessage.swift
//  PiDash
//
//  Created by Noah Peeters on 10.02.19.
//  Copyright © 2019 Noah Peeters. All rights reserved.
//

import Serializable

internal protocol ClientboundMessage: DeserializableDataType {
    static var id: Byte { get }

    func apply(to server: Server)
}
