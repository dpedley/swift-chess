import XCTest
@testable import Chess

final class ChessTests: XCTestCase {
    func testChess() {
        // Scholar's test
        let board = Chess.Board(FEN: Chess.Board.startingFEN)
        var move = Chess.Move(side: .white, start: .e2, end: .e4) // Kings pawn opens
        TestMove(board.attemptMove(&move))
        move = Chess.Move(side: .black, start: .e7, end: .e5) // Blacks pawn meets white
        TestMove(board.attemptMove(&move))
        move = Chess.Move(side: .white, start: .f1, end: .c4) // Bring out the bishop
        TestMove(board.attemptMove(&move))
        move = Chess.Move(side: .black, start: .d7, end: .d6) // Black plays safe
        TestMove(board.attemptMove(&move))
        move = Chess.Move(side: .white, start: .d1, end: .f3) // The queen prepares to pounce
        TestMove(board.attemptMove(&move))
        move = Chess.Move(side: .black, start: .b8, end: .c6) // Black doesn't see the attack
        TestMove(board.attemptMove(&move))
        move = Chess.Move(side: .white, start: .f3, end: .f7) // The queen mates in 4
        TestMove(board.attemptMove(&move))
        XCTAssertTrue(board.squareForActiveKing.isUnderAttack, "Expected king to be attacked and in mate.")
        XCTAssertFalse(board.areThereAnyValidMoves(), "Expected no moves available in mate.")
    }

    static var allTests = [
        ("testChess", testChess),
    ]
}
