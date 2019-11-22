//
//  ContentView.swift
//  PiDash
//
//  Created by Noah Peeters on 25.08.19.
//  Copyright © 2019 Noah Peeters. All rights reserved.
//

import BlueCom
import SwiftUI

internal struct ContentView: View {
    @State private var servers: [Server] = []
    @State private var selectedServer: Server? = nil

    internal var body: some View {
        NavigationView {
            List(servers) { server in
                ServerCell(server: server).onTapGesture {
                    ConnectionManager.shared.selectedServer.send(server)
                }
            }.onReceive(ConnectionManager.shared.serverManager.connectedServers.receive(on: DispatchQueue.main)) {
                self.servers = $0
            }
            .navigationBarTitle(selectedServer?.displayName ?? "No Server selected")
        }
        .onReceive(ConnectionManager.shared.selectedServer.receive(on: DispatchQueue.main)) { selectedServer in
            self.selectedServer = selectedServer
        }
    }
}

#if DEBUG
internal struct ContentView_Previews: PreviewProvider {
    internal static var previews: some View {
        ContentView()
    }
}
#endif
