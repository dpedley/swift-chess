import XCTest
@testable import Chess

final class ChessTests: XCTestCase {
    func testGameBoardSetup() {
        let board = Chess.Board(FEN: Chess.Board.startingFEN)
        XCTAssertEqual(board.squares[0].piece?.UI, Chess.UI.Piece.blackRook)
        XCTAssertEqual(board.squares[63].piece?.UI, Chess.UI.Piece.whiteRook)
    }

    static var allTests = [
        ("testGameBoardSetup", testGameBoardSetup),
    ]
}
