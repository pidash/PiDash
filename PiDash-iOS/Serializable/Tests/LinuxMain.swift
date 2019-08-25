import XCTest

import SerializableTests

var tests = [XCTestCaseEntry]()
tests += SerializableTests.allTests()
XCTMain(tests)
