import XCTest
@testable import Chess

final class PieceMoveTests: XCTestCase {
    func testPawns() {
        let pawn = Chess.Piece(side: .white, pieceType: .pawn(hasMoved: false))
        var e2e4 = Chess.Move.white.e2.e4 // Classic opening
        var b6h7 = Chess.Move.white.b6.h7 // A pawn can't do this
        XCTAssertTrue(pawn.isMoveValid(&e2e4))
        XCTAssertFalse(pawn.isMoveValid(&b6h7))
    }
    
    static var allTests = [
        ("testPawns", testPawns)
    ]
}

