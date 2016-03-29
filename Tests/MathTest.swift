import Phobos
import XCTest

final class MathTest: XCTestCase {
    func clamp_throwsIfMinIsGreaterThanMax() {
    }
}

#if os(Linux)
extension MathTest: XCTestCaseProvider {
    var allTests: [(String, () throws -> Void)] {
        return [
        ]
    }
}
#endif
