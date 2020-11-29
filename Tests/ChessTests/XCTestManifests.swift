import XCTest
@testable import Chess

extension XCTestCase {
    func TestWait(_ timeout: TimeInterval) {
        let waitABit = XCTestExpectation()
        Thread.detachNewThread {
            Thread.sleep(until: Date().addingTimeInterval(timeout))
            waitABit.fulfill()
        }
        _ = XCTWaiter.wait(for: [waitABit], timeout: timeout * 2)
    }
    func TestMove(_ attempt: Chess.Move.Result) {
        switch attempt {
        case .failed(let reason):
            XCTFail(reason.rawValue)
        default:
            break
        }
    }
}

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BoardFenTests.allTests),
        testCase(ChessTests.allTests),
        testCase(GameTests.allTests),
        testCase(PositionTests.allTests)
    ]
}
#endif
