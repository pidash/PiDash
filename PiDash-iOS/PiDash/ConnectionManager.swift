//
//  ConnectionManager.swift
//  PiDash
//
//  Created by Noah Peeters on 27.08.19.
//  Copyright © 2019 Noah Peeters. All rights reserved.
//

import BlueCom
import Combine
import Foundation

internal class ConnectionManager {
    internal static let shared = ConnectionManager()

    internal let serverManager = ServerManager()
    internal let selectedServer = CurrentValueSubject<Server?, Never>(nil)

    private var cancelables: [AnyCancellable] = []

    private init() {
        serverManager.connectedServers.sink { [weak self] servers in
            if let self = self {
                if let currentServer = self.selectedServer.value {
                    if !servers.contains(currentServer) {
                        self.selectedServer.send(servers.first)
                    }
                } else {
                    self.selectedServer.send(servers.first)
                }
            }
        }.store(in: &cancelables)
    }
}
