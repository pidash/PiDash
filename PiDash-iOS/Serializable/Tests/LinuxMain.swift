import XCTest

import SerializableTests

internal var tests = [XCTestCaseEntry]()

tests += SerializableTests.allTests()
XCTMain(tests)
