//
//  DebugPrint.swift
//  PiDash
//
//  Created by Noah Peeters on 27.08.19.
//  Copyright © 2019 Noah Peeters. All rights reserved.
//

import Foundation

/// Prints a message in deub mode.
/// - Parameter message: The message to print.
/// - Parameter file: The file in which the message was send.
/// - Parameter line: The line in which the message was send.
public func debugPrint(_ message: CustomDebugStringConvertible, file: StaticString = #file, line: Int = #line) {
    #if DEBUG
    // swiftlint:disable:next discouraged_print
    print("[DEBUG in \(file):\(line)]: \(message.debugDescription)")
    #endif
}
