//
//  BoardAnalysis.swift
//  
//
//  Created by Douglas Pedley on 12/18/20.
//

import Foundation

import XCTest
@testable import Chess

final class BoardAnalysisTests: XCTestCase {
    func testValidVariantsSacrifice() throws {
        // A board in a position where black's king can only be saved by taking the attacker
        let kingAttackedFEN = "4rrk1/1b3Bp1/1n3q1p/2p1N3/1p6/7P/PP3PP1/R2QR1K1 b Q - 0 24"
        var game = Chess.Game()
        game.board.resetBoard(FEN: kingAttackedFEN)
        let status = game.computeGameStatus()
        XCTAssertTrue(status != .mate)
        XCTAssertTrue(game.board.areThereAnyValidMoves(), "Expected the attack to be defended.")
        XCTAssertFalse(game.board.isKingMated(), "The king is not mated.")
        let variants = try XCTUnwrap(game.board.createValidVariants(for: game.board.playingSide, deepVariants: true))
        let moves = variants.compactMap { $0.move?.description }
        let knownMoves = ["f8f7", "f6f7", "g8h7", "g8h8"].sorted()
        XCTAssertTrue(moves.count==4, "Expected a board situation with exactly four possible moves," +
                        " got \(String(describing: moves.count))")
        XCTAssertEqual(moves.sorted(), knownMoves)
    }
    static var allTests = [
        ("testValidVariantsSacrifice", testValidVariantsSacrifice)
    ]
}
