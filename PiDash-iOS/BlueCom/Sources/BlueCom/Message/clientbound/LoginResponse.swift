//
//  LoginResponse.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct LoginResponse: ClientboundMessage {
    internal static var id: Byte = 0

    private let loginSucceeded: Bool

    internal init<Buffer: ByteReadBuffer>(from buffer: Buffer) throws {
        loginSucceeded = try Bool(from: buffer)
    }

    internal func apply(to server: Server) {
        server.handleLoginResponse(loginSucceeded: loginSucceeded)
    }
}
