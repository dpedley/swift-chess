import XCTest
@testable import Chess

final class MoveTests: XCTestCase {
    func testEnPassant() throws {
        // The kings with one pawn each remaining
        // White's pawn hasn't moved, and upon moving 2
        // squares, will pass black's pawn en passant
        let endGameFEN = "8/8/8/8/2k3p1/8/2K2P2/8 w - - 0 1"
        let board = Chess.Board(FEN: endGameFEN)
        let blackPawn = try XCTUnwrap(board.squares[.g4].piece)
        let whitePawn = try XCTUnwrap(board.squares[.f2].piece)
        XCTAssertEqual(blackPawn.UI, .blackPawn) // make sure the found pieces are the correct type
        XCTAssertEqual(whitePawn.UI, .whitePawn)
        
        var whiteMoveForwardTwo = Chess.Move(side: .white, start: .f2, end: .f4)
        TestMove(board.attemptMove(&whiteMoveForwardTwo))
        board.playingSide = .black
        var takeEnPassant = Chess.Move(side: .black, start: .g4, end: .f3)
        TestMove(board.attemptMove(&takeEnPassant))
    }
    
    func testPinnedPieces() throws {
        // There are 2 knights on the board that are each pinned and cannot move.
        let pinnedFEN = "r1b1kbnr/ppp1q1pp/2n5/1B3p2/3BN3/2P5/PP3PPP/R2QK1NR b KQkq - 0 1"
        let board = Chess.Board(FEN: pinnedFEN)
        let blackKnight = try XCTUnwrap(board.squares[.c6].piece)
        let whiteKnight = try XCTUnwrap(board.squares[.e4].piece)
        XCTAssertEqual(blackKnight.UI, .blackKnight)
        XCTAssertEqual(whiteKnight.UI, .whiteKnight)

        // Try to move the knights
        // - black
        var moveBlack = Chess.Move(side: .black, start: .c6, end: .d4)
        let blackPin = try XCTUnwrap(TestMoveFails(board.attemptMove(&moveBlack)))
        switch blackPin {
        case .kingWouldBeUnderAttackAfterMove:
            // Pinned as expected
            break
        default:
            XCTFail("Expected the black knight to be pinned.")
        }
        board.playingSide = .white
        // - white
        var moveWhite = Chess.Move(side: .white, start: .e4, end: .g3)
        let whitePin = try XCTUnwrap(TestMoveFails(board.attemptMove(&moveWhite)))
        switch whitePin {
        case .kingWouldBeUnderAttackAfterMove:
            // Pinned as expected
            break
        default:
            XCTFail("Expected the white knight to be pinned.")
        }
    }

    static var allTests = [
        ("testEnPassant", testEnPassant),
        ("testPinnedPieces", testPinnedPieces)
    ]
}

