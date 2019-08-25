//
//  LoginResponse.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct LoginResponse: ClientboundMessage {
    static var id: Byte = 0
    
    let loginSucceeded: Bool
    
    init<Buffer>(from buffer: Buffer) throws where Buffer : ByteReadBuffer {
        loginSucceeded = try Bool(from: buffer)
    }
    
    func apply(to server: Server) {
        server.handleLoginResponse(loginSucceeded: loginSucceeded)
    }
}
