//
//  ChessRobotTests.swift
//  
import XCTest
@testable import Chess

fileprivate let testTimeout: TimeInterval = 0.1

final class ChessRobotTests: XCTestCase {
    func testRandomBots() {
        let white = Chess.Robot.RandomBot(side: .white, matchLength: 3600)
        let black = Chess.Robot.RandomBot(side: .black, matchLength: 3600)
        let initialGame = Chess.Game(white, against: black)
        let store = ChessStore(initialGame: initialGame)
        let wait = testTimeout * 5
        store.game.nextTurn()
        TestWait(wait)
        XCTAssertEqual(store.game.board.fullMoves, 1)
        XCTAssertEqual(store.game.board.playingSide, .black)
        store.game.nextTurn()
        TestWait(wait)
        XCTAssertEqual(store.game.board.fullMoves, 2)
        XCTAssertEqual(store.game.board.playingSide, .white)
    }

    func testPlaybackBot() {
        let white = Chess.Robot.PlaybackBot(firstName: "fn0", lastName: "ln0", side: .white,
                                         moves: ["e2e4", "d2d3"], responseDelay: testTimeout)
        let black = Chess.Robot.PlaybackBot(firstName: "fn1", lastName: "ln1", side: .black,
                                         moves: ["e7e5", "d7d6"], responseDelay: testTimeout)
        let initialGame = Chess.Game(white, against: black)
        let store = ChessStore(initialGame: initialGame)
        let wait = testTimeout * 5
        store.game.nextTurn()
        TestWait(wait)
        XCTAssertEqual(store.game.board.fullMoves, 1)
        XCTAssertEqual(store.game.board.playingSide, .black)
        store.game.nextTurn()
        TestWait(wait)
        XCTAssertEqual(store.game.board.fullMoves, 2)
        XCTAssertEqual(store.game.board.playingSide, .white)
        store.game.nextTurn()
        TestWait(wait)
        XCTAssertEqual(store.game.board.fullMoves, 2)
        XCTAssertEqual(store.game.board.playingSide, .black)
        store.game.nextTurn()
        TestWait(wait)
        XCTAssertEqual(store.game.board.fullMoves, 3)
        XCTAssertEqual(store.game.board.playingSide, .white)
        XCTAssertEqual(store.game.board.FEN, "rnbqkbnr/ppp2ppp/3p4/4p3/4P3/3P4/PPP2PPP/RNBQKBNR w KQkq - 0 3")
    }

    static var allTests = [
        ("testPlaybackBot", testPlaybackBot),
        ("testRandomBots", testRandomBots)
    ]
}
