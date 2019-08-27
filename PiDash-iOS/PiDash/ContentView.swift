//
//  ContentView.swift
//  PiDash
//
//  Created by Noah Peeters on 25.08.19.
//  Copyright © 2019 Noah Peeters. All rights reserved.
//

import SwiftUI

internal struct ContentView: View {
    internal var body: some View {
        Text("Hello World")
    }
}

#if DEBUG
internal struct ContentView_Previews: PreviewProvider {
    internal static var previews: some View {
        ContentView()
    }
}
#endif
