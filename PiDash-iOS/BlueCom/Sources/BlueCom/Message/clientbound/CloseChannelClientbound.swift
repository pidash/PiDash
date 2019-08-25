//
//  CloseChannelClientbound.swift
//  
//
//  Created by Noah Peeters on 25.08.19.
//

import Foundation
import Serializable

internal struct CloseChannelClientbound: ClientboundMessage {
    static var id: Byte = 2
    
    let channelID: ChannelID
    let error: String?
    
    internal init<Buffer>(from buffer: Buffer) throws where Buffer : ByteReadBuffer {
        channelID = try ChannelID(from: buffer)
        error = try String?(from: buffer)
    }
    
    func apply(to server: Server) {
        server.channelClosedFromServer(channelID: channelID, error: error)
    }
}
