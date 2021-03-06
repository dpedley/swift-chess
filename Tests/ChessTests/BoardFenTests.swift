//
//  BoardFenTests.swift
//  
//
//  Created by Douglas Pedley on 11/28/20.
//

import XCTest
@testable import Chess

final class BoardFenTests: XCTestCase {
    func testBoardstartingFEN() {
        let board = Chess.Board(FEN: Chess.Board.startingFEN)
        XCTAssertEqual(board.squares[0].piece?.UI, Chess.PieceGlyph.blackRook)
        XCTAssertEqual(board.squares[1].piece?.UI, Chess.PieceGlyph.blackKnight)
        XCTAssertEqual(board.squares[2].piece?.UI, Chess.PieceGlyph.blackBishop)
        XCTAssertEqual(board.squares[3].piece?.UI, Chess.PieceGlyph.blackQueen)
        XCTAssertEqual(board.squares[4].piece?.UI, Chess.PieceGlyph.blackKing)
        XCTAssertEqual(board.squares[5].piece?.UI, Chess.PieceGlyph.blackBishop)
        XCTAssertEqual(board.squares[6].piece?.UI, Chess.PieceGlyph.blackKnight)
        XCTAssertEqual(board.squares[7].piece?.UI, Chess.PieceGlyph.blackRook)
        XCTAssertEqual(board.squares[56].piece?.UI, Chess.PieceGlyph.whiteRook)
        XCTAssertEqual(board.squares[57].piece?.UI, Chess.PieceGlyph.whiteKnight)
        XCTAssertEqual(board.squares[58].piece?.UI, Chess.PieceGlyph.whiteBishop)
        XCTAssertEqual(board.squares[59].piece?.UI, Chess.PieceGlyph.whiteQueen)
        XCTAssertEqual(board.squares[60].piece?.UI, Chess.PieceGlyph.whiteKing)
        XCTAssertEqual(board.squares[61].piece?.UI, Chess.PieceGlyph.whiteBishop)
        XCTAssertEqual(board.squares[62].piece?.UI, Chess.PieceGlyph.whiteKnight)
        XCTAssertEqual(board.squares[63].piece?.UI, Chess.PieceGlyph.whiteRook)
    }

    func testZugDraw() {
        // A board in a position where white has only three legal moves
        // and after the move, the game is a draw
        let zugDraw = "k7/2q2p2/1Q3p2/KP3P1p/P6P/8/8/8 w - - 0 1"
        var board = Chess.Board(FEN: zugDraw)
        let moves = board.createValidVariants(for: board.playingSide, deepVariants: true)
        var moveStrings: [String] = []
        if let moves = moves {
            for move in moves {
                guard let moveString = move.move?.description else { continue }
                moveStrings.append(moveString)
            }
        }
        XCTAssertTrue(moves?.count==3, "Expected a board situation with only three possible moves," +
                        " got \(String(describing: moves?.count))")
        let queenTakesQueen = moves?.first(where: { variant -> Bool in
            guard let start = variant.move?.start,
                  let piece = board.squares[start].piece?.pieceType else {
                return false
            }
            return piece.isQueen()
        })

        var qtq = Chess.Move.white.b6.c7
        testMove(board.attemptMove(&qtq))
        board.playingSide = qtq.side.opposingSide

        XCTAssertNotNil(queenTakesQueen, "Cannot find critical move, queen takes queen")
        guard var move = queenTakesQueen?.move else {
            XCTFail("No move for queen to take queen.")
            return
        }
        let attempt = board.attemptMove(&move)
        switch attempt {
        case .success(let otherQueen):
            XCTAssertTrue(otherQueen?.pieceType.isQueen() ?? false, "Expected to capture the opponents queen")
        default:
            break
        }
        XCTAssertFalse(board.areThereAnyValidMoves(),
                       "Expected the board to be in a draw state after queen takes queen.")
    }
    func testRepetitionDraw() {
        let white = Chess.HumanPlayer(side: .white)
        let black = Chess.HumanPlayer(side: .black)
        var game = Chess.Game(white, against: black)
        game.userPaused = false
        game.execute(move: Chess.Move.white.e2.e4)
        game.changeSides(.black)
        game.execute(move: Chess.Move.black.e7.e5)
        game.changeSides(.white)
        game.execute(move: Chess.Move.white.d1.g4)
        game.changeSides(.black)
        game.execute(move: Chess.Move.black.d8.g5)
        game.changeSides(.white)
        game.execute(move: Chess.Move.white.g4.d1)
        game.changeSides(.black)
        game.execute(move: Chess.Move.black.g5.d8)
        game.changeSides(.white)
        game.execute(move: Chess.Move.white.d1.g4)
        game.changeSides(.black)
        game.execute(move: Chess.Move.black.d8.g5)
        game.changeSides(.white)
        game.execute(move: Chess.Move.white.g4.d1)
        let preStatus = game.computeGameStatus()
        XCTAssertTrue(preStatus == .active,
                      "Expected active")
        game.changeSides(.black)
        game.execute(move: Chess.Move.black.g5.d8)
        let status = game.computeGameStatus()
        XCTAssertTrue(status == .drawByRepetition,
                      "Expected a draw got \(status)")
    }
    func testInsufficientMaterialDraw() {
        let draw = "8/8/8/4K3/7N/6k1/8/8 w - - 0 50"
        var game = Chess.Game()
        game.board.resetBoard(FEN: draw)
        game.board.turns.append(.init(0, white: Chess.Move.white.e2.e4, black: nil))
        let status = game.computeGameStatus()
        XCTAssertTrue(status == .drawBecauseOfInsufficientMatingMaterial,
                      "Expected a draw got \(status)")
    }
    func testFiftyMoveDraw() {
        let draw = "8/8/4k3/2p5/2P5/3K4/8/8 w - - 49 62"
        let white = Chess.HumanPlayer(side: .white)
        let black = Chess.HumanPlayer(side: .black)
        var game = Chess.Game(white, against: black)
        game.userPaused = false
        game.board.resetBoard(FEN: draw)
        game.board.turns.append(.init(0, white: Chess.Move.black.d6.e6, black: nil))
        let status = game.computeGameStatus()
        XCTAssertTrue(status == .active,
                      "Expected active got \(status)")
        game.execute(move: Chess.Move.white.d3.e3)
        game.changeSides(.black)
        let newStatus = game.computeGameStatus()
        XCTAssertTrue(newStatus == .drawByMoves, "Expected a draw got \(newStatus)")
    }
    static var allTests = [
        ("testBoardstartingFEN", testBoardstartingFEN),
        ("testZugDraw", testZugDraw),
        ("testInsufficientMaterialDraw", testInsufficientMaterialDraw),
        ("testRepetitionDraw", testRepetitionDraw),
        ("testFiftyMoveDraw", testFiftyMoveDraw)
    ]
}
