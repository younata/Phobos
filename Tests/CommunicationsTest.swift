import XCTest
import Jay
import Phobos

final class CommunicationsTest: XCTestCase {
}

#if os(Linux)
extension CommunicationsTest: XCTestCaseProvider {
    var allTests : [(String, () throws -> Void)] {
        return [
            ("testGetRequestWithOneArg", testGetRequestWithOneArg),
            ("testGetRequestStatusCode", testGetRequestStatusCode),
        ]
    }
}
#endif
