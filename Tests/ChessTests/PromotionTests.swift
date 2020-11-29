//
//  PromotionTests.swift
import XCTest
@testable import Chess

final class PromotionTests: XCTestCase {
    func testBecomesQueen() {
        let promoteFEN = "8/8/8/8/8/1k6/4p3/K7 b - - 0 1"
        let promotedFEN = "8/8/8/8/8/1k6/8/K3q3 w - - 0 2"
        
        // First without explicit promotion declaration
        let board1 = Chess.Board(FEN: promoteFEN)
        var move1 = Chess.Move.black.e2.e1 // black's pawn moves to first rank
        TestMove(board1.attemptMove(&move1))
        XCTAssertEqual(board1.FEN, promotedFEN)
        
        // Next with explicit queen promotion
        let board2 = Chess.Board(FEN: promoteFEN)
        var move2 = Chess.Move.black.e2.e1 // black's pawn moves to first rank
        move2.sideEffect = .promotion(piece: .init(side: .black, pieceType: .queen(hasMoved: true)))
        TestMove(board2.attemptMove(&move2))
        XCTAssertEqual(board2.FEN, promotedFEN)
        
        // White should be in mate on both boards
        XCTAssertFalse(board1.areThereAnyValidMoves())
        XCTAssertFalse(board2.areThereAnyValidMoves())
    }
    
    func testBecomesRook() {
        let promoteFEN = "1k6/3P4/1K6/8/8/8/8/8 w - - 0 1"
        let promotedFEN = "1k1R4/8/1K6/8/8/8/8/8 b - - 0 1"
        
        // Rook promotion
        let board = Chess.Board(FEN: promoteFEN)
        var move = Chess.Move.white.d7.d8 // white's pawn moves to eighth rank
        move.sideEffect = .promotion(piece: .init(side: .white, pieceType: .rook(hasMoved: true, isKingSide: false)))
        TestMove(board.attemptMove(&move))
        XCTAssertEqual(board.FEN, promotedFEN)
        
        // Black should be in mate
        XCTAssertFalse(board.areThereAnyValidMoves())
    }

    func testBecomesBishop() {
        let promoteFEN = "R7/8/8/8/4r3/K1k5/P1p5/8 b - - 0 1"
        let promotedFEN = "R7/8/8/8/4r3/K1k5/P7/2b5 w - - 0 2"
        
        // Rook promotion
        let board = Chess.Board(FEN: promoteFEN)
        var move = Chess.Move.black.c2.c1 // black's pawn moves to first rank
        move.sideEffect = .promotion(piece: .init(side: .black, pieceType: .bishop(hasMoved: true)))
        TestMove(board.attemptMove(&move))
        XCTAssertEqual(board.FEN, promotedFEN)
        
        // Black should be in mate
        XCTAssertFalse(board.areThereAnyValidMoves())
    }
    
    func testBecomesKnight() {
        let promoteFEN = "8/8/8/8/8/P1p5/K1p5/RB1k4 b - - 0 1"
        let promotedFEN = "8/8/8/8/8/P1p5/K7/RBnk4 w - - 0 2"
        
        // Knight promotion
        let board = Chess.Board(FEN: promoteFEN)
        var move = Chess.Move.black.c2.c1 // black's pawn moves to first rank
        move.sideEffect = .promotion(piece: .init(side: .black, pieceType: .knight(hasMoved: true)))
        TestMove(board.attemptMove(&move))
        XCTAssertEqual(board.FEN, promotedFEN)
        
        // Black should be in mate
        XCTAssertFalse(board.areThereAnyValidMoves())
    }

    
    static var allTests = [
        ("testBecomesQueen", testBecomesQueen),
        ("testBecomesRook", testBecomesRook),
        ("testBecomesBishop", testBecomesBishop),
        ("testBecomesKnight", testBecomesKnight)
    ]
}
