//
//  ChannelDataClientbound.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct ChannelDataClientbound: ClientboundMessage {
    static var id: Byte = 1
    
    let channleID: ChannelID
    let data: Data
    
    internal init<Buffer>(from buffer: Buffer) throws where Buffer : ByteReadBuffer {
        try channleID = ChannelID(from: buffer)
        try data = Data(from: buffer)
    }
    
    func apply(to server: Server) {
        server.receivedData(data, for: channleID)
    }
}
