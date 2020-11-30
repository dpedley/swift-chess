import XCTest
@testable import Chess

final class ChessTests: XCTestCase {
    func testOpeningsCount() {
        let board = Chess.Board(FEN: Chess.Board.startingFEN)
        let openings = board.createValidVariants(for: .white)
        XCTAssertEqual(openings?.count, 20)
    }
    
    func testFastestMate() {
        // Scholars mate test
        let board = Chess.Board(FEN: Chess.Board.startingFEN)
        var move = Chess.Move.white.e2.e4 // Kings pawn opens
        TestMove(board.attemptMove(&move))
        move = Chess.Move.black.e7.e5 // Blacks pawn meets white
        TestMove(board.attemptMove(&move))
        move = Chess.Move.white.f1.c4 // Bring out the bishop
        TestMove(board.attemptMove(&move))
        move = Chess.Move.black.d7.d6 // Black plays safe
        TestMove(board.attemptMove(&move))
        move = Chess.Move.white.d1.f3 // The queen prepares to pounce
        TestMove(board.attemptMove(&move))
        move = Chess.Move.black.b8.c6 // Black doesn't see the attack
        TestMove(board.attemptMove(&move))
        move = Chess.Move.white.f3.f7 // The queen mates in 4
        TestMove(board.attemptMove(&move))
        XCTAssertTrue(board.squareForActiveKing.isUnderAttack, "Expected king to be attacked and in mate.")
        XCTAssertFalse(board.areThereAnyValidMoves(), "Expected no moves available in mate.")
    }

    static var allTests = [
        ("testOpeningsCount", testOpeningsCount),
        ("testFastestMate", testFastestMate)
    ]
}
