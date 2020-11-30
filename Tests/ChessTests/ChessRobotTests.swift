//
//  ChessRobotTests.swift
//  
import XCTest
@testable import Chess

fileprivate let testTimeout: TimeInterval = 0.1

final class ChessRobotTests: XCTestCase {
    func testRandomBots() {
        let white = Chess.Player.RandomBot(side: .white, matchLength: 3600)
        let black = Chess.Player.RandomBot(side: .black, matchLength: 3600)
        let game = Chess.Game(white, against: black)
        let wait = testTimeout * 2
        game.board.resetBoard()
        game.nextTurn()
        TestWait(wait)
        XCTAssertEqual(game.board.fullMoves, 1)
        XCTAssertEqual(game.board.playingSide, .black)
        game.nextTurn()
        TestWait(wait)
        XCTAssertEqual(game.board.fullMoves, 2)
        XCTAssertEqual(game.board.playingSide, .white)
    }

    static var allTests = [
        ("testRandomBots", testRandomBots),
    ]
}
