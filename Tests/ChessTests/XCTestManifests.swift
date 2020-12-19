import XCTest
import Combine
@testable import Chess

extension XCTestCase {
    func testMove(_ attempt: Chess.MoveResult) {
        switch attempt {
        case .failure(let reason):
            XCTFail(reason.rawValue)
        default:
            break
        }
    }
    func testMoveFails(_ attempt: Chess.MoveResult) -> Chess.Move.Limitation? {
        switch attempt {
        case .failure(let reason):
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
        testCase(BoardAnalysisTests.allTests),
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
        testCase(RankAndFilesTests.allTests)]
}
#endif
