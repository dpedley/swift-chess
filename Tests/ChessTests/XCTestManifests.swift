import XCTest
import Combine
@testable import Chess

extension XCTestCase {
    func TestMove(_ attempt: Chess.Move.Result) {
        switch attempt {
        case .failed(let reason):
            XCTFail(reason.rawValue)
        default:
            break
        }
    }
    func TestMoveFails(_ attempt: Chess.Move.Result) -> Chess.Move.Limitation? {
        switch attempt {
        case .failed(let reason):
            return reason
        default:
            break
        }
        XCTFail("Test Move was meant to fail, but didn't.")
        return nil
    }
}

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BoardFenTests.allTests),
        testCase(ChessRobotTests.allTests),
        testCase(ChessTests.allTests),
        testCase(GameTests.allTests),
        testCase(MoveTests.allTests),
        testCase(NamedPositionTests.allTests),
        testCase(PieceMoveTests.allTests),
        testCase(PieceWeightTests.allTests),
        testCase(PositionTests.allTests),
        testCase(PromotionTests.allTests),
        testCase(RankAndFilesTests.allTests)
    ]
}
#endif
