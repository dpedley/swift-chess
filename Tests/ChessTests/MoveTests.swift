import XCTest
@testable import Chess

final class MoveTests: XCTestCase {
    func testMoveEquality() {
        let e2e4 = Chess.Move.white.e2.e4
        let alsoE2E4 = Chess.Move(side: .white,
                                  start: Chess.Position.from(rankAndFile: "e2"),
                                  end: Chess.Position.from(rankAndFile: "e4"))
        XCTAssertTrue(e2e4==alsoE2E4)
    }

    func testEnPassant() throws {
        // The kings with one pawn each remaining
        // White's pawn hasn't moved, and upon moving 2
        // squares, will pass black's pawn en passant
        let endGameFEN = "8/8/8/8/2k3p1/8/2K2P2/8 w - - 0 1"
        var board = Chess.Board(FEN: endGameFEN)
        let blackPawn = try XCTUnwrap(board.squares[.g4].piece)
        let whitePawn = try XCTUnwrap(board.squares[.f2].piece)
        XCTAssertEqual(blackPawn.UI, .blackPawn) // make sure the found pieces are the correct type
        XCTAssertEqual(whitePawn.UI, .whitePawn)
        var whiteMoveForwardTwo = Chess.Move.white.f2.f4
        testMove(board.attemptMove(&whiteMoveForwardTwo))
        board.turns.append(Chess.Turn(0, white: whiteMoveForwardTwo, black: nil))
        board.playingSide = .black
        var takeEnPassant = Chess.Move.black.g4.f3
        testMove(board.attemptMove(&takeEnPassant))
    }

    func testPinnedPieces() throws {
        // There are 2 knights on the board that are each pinned and cannot move.
        let pinnedFEN = "r1b1kbnr/ppp1q1pp/2n5/1B3p2/3BN3/2P5/PP3PPP/R2QK1NR b KQkq - 0 1"
        var board = Chess.Board(FEN: pinnedFEN)
        let blackKnight = try XCTUnwrap(board.squares[.c6].piece)
        let whiteKnight = try XCTUnwrap(board.squares[.e4].piece)
        XCTAssertEqual(blackKnight.UI, .blackKnight)
        XCTAssertEqual(whiteKnight.UI, .whiteKnight)
        // Try to move the knights
        // - black
        var moveBlack = Chess.Move.black.c6.d4
        let blackPin = try XCTUnwrap(testMoveFails(board.attemptMove(&moveBlack)))
        switch blackPin {
        case .kingWouldBeUnderAttackAfterMove:
            // Pinned as expected
            break
        default:
            XCTFail("Expected the black knight to be pinned.")
        }
        board.playingSide = .white
        // - white
        var moveWhite = Chess.Move.white.e4.g3
        let whitePin = try XCTUnwrap(testMoveFails(board.attemptMove(&moveWhite)))
        switch whitePin {
        case .kingWouldBeUnderAttackAfterMove:
            // Pinned as expected
            break
        default:
            XCTFail("Expected the white knight to be pinned.")
        }
    }

    func testKingSideCastles() throws {
        let bothSidesCastleFEN = "rnbqk2r/pppp1pbp/5np1/4p3/2B1P3/5N1P/PPPP1PP1/RNBQK2R w KQkq - 0 1"
        let castledFEN = "rnbq1rk1/pppp1pbp/5np1/4p3/2B1P3/5N1P/PPPP1PP1/RNBQ1RK1 w - - 0 1"
        var board = Chess.Board(FEN: bothSidesCastleFEN)
        let blackKing = try XCTUnwrap(board.squares[.e8].piece)
        let whiteKing = try XCTUnwrap(board.squares[.e1].piece)
        XCTAssertEqual(blackKing.UI, .blackKing) // make sure the found pieces are the correct type
        XCTAssertEqual(whiteKing.UI, .whiteKing)
        var whiteCastles = Chess.Move.white.castleKingside
        testMove(board.attemptMove(&whiteCastles))
        board.playingSide = .black
        var blackCastles = Chess.Move.black.O_O // another name for castleKingside
        testMove(board.attemptMove(&blackCastles))
        board.playingSide = .white
        XCTAssertEqual(board.FEN, castledFEN)
    }

    func testQueenSideCastles() throws {
        let bothSidesCastleFEN = "r3kbnr/pppnpppp/3qb3/3p2B1/3P4/2N5/PPPQPPPP/R3KBNR w KQkq - 0 1"
        let castledFEN = "2kr1bnr/pppnpppp/3qb3/3p2B1/3P4/2N5/PPPQPPPP/2KR1BNR w - - 0 1"
        var board = Chess.Board(FEN: bothSidesCastleFEN)
        let blackKing = try XCTUnwrap(board.squares[.e8].piece)
        let whiteKing = try XCTUnwrap(board.squares[.e1].piece)
        XCTAssertEqual(blackKing.UI, .blackKing) // make sure the found pieces are the correct type
        XCTAssertEqual(whiteKing.UI, .whiteKing)
        var whiteCastles = Chess.Move.white.O_O_O // another name for castleQueenside
        testMove(board.attemptMove(&whiteCastles))
        board.playingSide = .black
        var blackCastles = Chess.Move.black.castleQueenside // another name for O_O_O
        testMove(board.attemptMove(&blackCastles))
        board.playingSide = .white
        XCTAssertEqual(board.FEN, castledFEN)
    }

    static var allTests = [
        ("testMoveEquality", testMoveEquality),
        ("testEnPassant", testEnPassant),
        ("testPinnedPieces", testPinnedPieces),
        ("testKingSideCastles", testKingSideCastles),
        ("testQueenSideCastles", testQueenSideCastles)
    ]
}
