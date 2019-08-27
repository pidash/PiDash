import XCTest

#if !canImport(ObjectiveC)
internal func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BlueComTests.allTests)
    ]
}
#endif
