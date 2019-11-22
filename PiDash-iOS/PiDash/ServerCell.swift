//
//  ServerCell.swift
//  PiDash
//
//  Created by Noah Peeters on 27.08.19.
//  Copyright © 2019 Noah Peeters. All rights reserved.
//

import BlueCom
import SwiftUI

internal struct ServerCell: View {
    internal let server: Server
    @State internal var isReady: Bool = false

    internal var body: some View {
        Text((server.displayName ?? "Unknown Device") + " \(isReady ? "Ready" : "Not Ready")")
            .onReceive(server.isReady.receive(on: DispatchQueue.main)) { self.isReady = $0 }
    }
}
