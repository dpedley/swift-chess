import XCTest
@testable import Chess

final class NamedPositionTests: XCTestCase {
    func testPieceGroups() {
        let board = Chess.Board(FEN: Chess.Board.startingFEN)
        let blackPawns = Chess.Rules.startingPositionsForBlackPawns.compactMap { board.squares[$0].piece }
        let whitePawns = Chess.Rules.startingPositionsForWhitePawns.compactMap { board.squares[$0].piece }
        let blackKnights = Chess.Rules.startingPositionsForBlackKnights.compactMap { board.squares[$0].piece }
        let whiteKnights = Chess.Rules.startingPositionsForWhiteKnights.compactMap { board.squares[$0].piece }
        let blackBishops = Chess.Rules.startingPositionsForBlackBishops.compactMap { board.squares[$0].piece }
        let whiteBishops = Chess.Rules.startingPositionsForWhiteBishops.compactMap { board.squares[$0].piece }
        let blackRooks = Chess.Rules.startingPositionsForBlackRooks.compactMap { board.squares[$0].piece }
        let whiteRooks = Chess.Rules.startingPositionsForWhiteRooks.compactMap { board.squares[$0].piece }
        XCTAssertEqual(blackPawns.count, 8)
        XCTAssertEqual(whitePawns.count, 8)
        XCTAssertEqual(blackKnights.count, 2)
        XCTAssertEqual(whiteKnights.count, 2)
        XCTAssertEqual(blackBishops.count, 2)
        XCTAssertEqual(whiteBishops.count, 2)
        XCTAssertEqual(blackRooks.count, 2)
        XCTAssertEqual(whiteRooks.count, 2)

        let whiteKingSideRook = Chess.Rules.startingPositionForRook(side: .white, kingSide: true)
        let whiteQueenSideRook = Chess.Rules.startingPositionForRook(side: .white, kingSide: true)
        let blackKingSideRook = Chess.Rules.startingPositionForRook(side: .black, kingSide: true)
        let blackQueenSideRook = Chess.Rules.startingPositionForRook(side: .black, kingSide: true)
        XCTAssertTrue(board.squares[whiteKingSideRook].piece?.FEN == "R")
        XCTAssertTrue(board.squares[whiteQueenSideRook].piece?.FEN == "R")
        XCTAssertTrue(board.squares[blackKingSideRook].piece?.FEN == "r")
        XCTAssertTrue(board.squares[blackQueenSideRook].piece?.FEN == "r")

        // walk the board
        for square in board.squares {
            guard let piece = square.piece else { continue }
            XCTAssertTrue(board.isValid(startingSquare: square, for: piece),
                          "The square \(square.position.FEN) - \(square.position.rawIndex) doesn't like \(piece.FEN)")
        }
    }

    // swiftlint:disable function_body_length
    func testPositionNames() {
        XCTAssertEqual(Chess.Position.a1, Chess.Position.from(rankAndFile: "a1"))
        XCTAssertEqual(Chess.Position.a2, Chess.Position.from(rankAndFile: "a2"))
        XCTAssertEqual(Chess.Position.a3, Chess.Position.from(rankAndFile: "a3"))
        XCTAssertEqual(Chess.Position.a4, Chess.Position.from(rankAndFile: "a4"))
        XCTAssertEqual(Chess.Position.a5, Chess.Position.from(rankAndFile: "a5"))
        XCTAssertEqual(Chess.Position.a6, Chess.Position.from(rankAndFile: "a6"))
        XCTAssertEqual(Chess.Position.a7, Chess.Position.from(rankAndFile: "a7"))
        XCTAssertEqual(Chess.Position.a8, Chess.Position.from(rankAndFile: "a8"))
        XCTAssertEqual(Chess.Position.b1, Chess.Position.from(rankAndFile: "b1"))
        XCTAssertEqual(Chess.Position.b2, Chess.Position.from(rankAndFile: "b2"))
        XCTAssertEqual(Chess.Position.b3, Chess.Position.from(rankAndFile: "b3"))
        XCTAssertEqual(Chess.Position.b4, Chess.Position.from(rankAndFile: "b4"))
        XCTAssertEqual(Chess.Position.b5, Chess.Position.from(rankAndFile: "b5"))
        XCTAssertEqual(Chess.Position.b6, Chess.Position.from(rankAndFile: "b6"))
        XCTAssertEqual(Chess.Position.b7, Chess.Position.from(rankAndFile: "b7"))
        XCTAssertEqual(Chess.Position.b8, Chess.Position.from(rankAndFile: "b8"))
        XCTAssertEqual(Chess.Position.c1, Chess.Position.from(rankAndFile: "c1"))
        XCTAssertEqual(Chess.Position.c2, Chess.Position.from(rankAndFile: "c2"))
        XCTAssertEqual(Chess.Position.c3, Chess.Position.from(rankAndFile: "c3"))
        XCTAssertEqual(Chess.Position.c4, Chess.Position.from(rankAndFile: "c4"))
        XCTAssertEqual(Chess.Position.c5, Chess.Position.from(rankAndFile: "c5"))
        XCTAssertEqual(Chess.Position.c6, Chess.Position.from(rankAndFile: "c6"))
        XCTAssertEqual(Chess.Position.c7, Chess.Position.from(rankAndFile: "c7"))
        XCTAssertEqual(Chess.Position.c8, Chess.Position.from(rankAndFile: "c8"))
        XCTAssertEqual(Chess.Position.d1, Chess.Position.from(rankAndFile: "d1"))
        XCTAssertEqual(Chess.Position.d2, Chess.Position.from(rankAndFile: "d2"))
        XCTAssertEqual(Chess.Position.d3, Chess.Position.from(rankAndFile: "d3"))
        XCTAssertEqual(Chess.Position.d4, Chess.Position.from(rankAndFile: "d4"))
        XCTAssertEqual(Chess.Position.d5, Chess.Position.from(rankAndFile: "d5"))
        XCTAssertEqual(Chess.Position.d6, Chess.Position.from(rankAndFile: "d6"))
        XCTAssertEqual(Chess.Position.d7, Chess.Position.from(rankAndFile: "d7"))
        XCTAssertEqual(Chess.Position.d8, Chess.Position.from(rankAndFile: "d8"))
        XCTAssertEqual(Chess.Position.e1, Chess.Position.from(rankAndFile: "e1"))
        XCTAssertEqual(Chess.Position.e2, Chess.Position.from(rankAndFile: "e2"))
        XCTAssertEqual(Chess.Position.e3, Chess.Position.from(rankAndFile: "e3"))
        XCTAssertEqual(Chess.Position.e4, Chess.Position.from(rankAndFile: "e4"))
        XCTAssertEqual(Chess.Position.e5, Chess.Position.from(rankAndFile: "e5"))
        XCTAssertEqual(Chess.Position.e6, Chess.Position.from(rankAndFile: "e6"))
        XCTAssertEqual(Chess.Position.e7, Chess.Position.from(rankAndFile: "e7"))
        XCTAssertEqual(Chess.Position.e8, Chess.Position.from(rankAndFile: "e8"))
        XCTAssertEqual(Chess.Position.f1, Chess.Position.from(rankAndFile: "f1"))
        XCTAssertEqual(Chess.Position.f2, Chess.Position.from(rankAndFile: "f2"))
        XCTAssertEqual(Chess.Position.f3, Chess.Position.from(rankAndFile: "f3"))
        XCTAssertEqual(Chess.Position.f4, Chess.Position.from(rankAndFile: "f4"))
        XCTAssertEqual(Chess.Position.f5, Chess.Position.from(rankAndFile: "f5"))
        XCTAssertEqual(Chess.Position.f6, Chess.Position.from(rankAndFile: "f6"))
        XCTAssertEqual(Chess.Position.f7, Chess.Position.from(rankAndFile: "f7"))
        XCTAssertEqual(Chess.Position.f8, Chess.Position.from(rankAndFile: "f8"))
        XCTAssertEqual(Chess.Position.g1, Chess.Position.from(rankAndFile: "g1"))
        XCTAssertEqual(Chess.Position.g2, Chess.Position.from(rankAndFile: "g2"))
        XCTAssertEqual(Chess.Position.g3, Chess.Position.from(rankAndFile: "g3"))
        XCTAssertEqual(Chess.Position.g4, Chess.Position.from(rankAndFile: "g4"))
        XCTAssertEqual(Chess.Position.g5, Chess.Position.from(rankAndFile: "g5"))
        XCTAssertEqual(Chess.Position.g6, Chess.Position.from(rankAndFile: "g6"))
        XCTAssertEqual(Chess.Position.g7, Chess.Position.from(rankAndFile: "g7"))
        XCTAssertEqual(Chess.Position.g8, Chess.Position.from(rankAndFile: "g8"))
        XCTAssertEqual(Chess.Position.h1, Chess.Position.from(rankAndFile: "h1"))
        XCTAssertEqual(Chess.Position.h2, Chess.Position.from(rankAndFile: "h2"))
        XCTAssertEqual(Chess.Position.h3, Chess.Position.from(rankAndFile: "h3"))
        XCTAssertEqual(Chess.Position.h4, Chess.Position.from(rankAndFile: "h4"))
        XCTAssertEqual(Chess.Position.h5, Chess.Position.from(rankAndFile: "h5"))
        XCTAssertEqual(Chess.Position.h6, Chess.Position.from(rankAndFile: "h6"))
        XCTAssertEqual(Chess.Position.h7, Chess.Position.from(rankAndFile: "h7"))
        XCTAssertEqual(Chess.Position.h8, Chess.Position.from(rankAndFile: "h8"))
    }
    // swiftlint:enable function_body_length

    func testMovePositions() {
        XCTAssertEqual(Chess.Move.black.a1.h8.description, "a1h8")
        XCTAssertEqual(Chess.Move.black.a2.a3.description, "a2a3")
        XCTAssertEqual(Chess.Move.black.c1.d3.description, "c1d3")
        XCTAssertEqual(Chess.Move.black.b4.b1.description, "b4b1")
        XCTAssertEqual(Chess.Move.black.d8.a5.description, "d8a5")
        XCTAssertEqual(Chess.Move.black.e6.a6.description, "e6a6")
        XCTAssertEqual(Chess.Move.black.f8.f7.description, "f8f7")
        XCTAssertEqual(Chess.Move.black.h8.a1.description, "h8a1")
        XCTAssertEqual(Chess.Move.black.O_O.description, "e8g8")
        XCTAssertEqual(Chess.Move.black.castleQueenside.description, "e8c8")
        XCTAssertEqual(Chess.Move.white.castleKingside.description, "e1g1")
        XCTAssertEqual(Chess.Move.white.O_O_O.description, "e1c1")
    }

    static var allTests = [
        ("testPieceGroups", testPieceGroups),
        ("testPositionNames", testPositionNames),
        ("testMovePositions", testMovePositions)
    ]
}
