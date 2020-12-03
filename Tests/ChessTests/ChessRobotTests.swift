//
//  ChessRobotTests.swift
//  
import XCTest
@testable import Chess

fileprivate let testTimeout: TimeInterval = 0.25

final class ChessRobotTests: XCTestCase {
    func testRandomBots() {
        let white = Chess.Robot.RandomBot(side: .white)
        let black = Chess.Robot.RandomBot(side: .black)
        let initialGame = Chess.Game(white, against: black)
        let store = ChessStore(initialGame: initialGame)
        store.send(.nextTurn)
        TestWait(testTimeout)
        XCTAssertEqual(store.game.board.fullMoves, 1)
        XCTAssertEqual(store.game.board.playingSide, .black)
        store.send(.nextTurn)
        TestWait(testTimeout)
        XCTAssertEqual(store.game.board.fullMoves, 2)
        XCTAssertEqual(store.game.board.playingSide, .white)
    }

    func testPlaybackBot() {
        let initialGame = Chess.Robot.playback(moves: [
            Chess.Move.white.e2.e4, Chess.Move.black.e7.e5,
            Chess.Move.white.d2.d3, Chess.Move.black.d7.d6])
        let store = ChessStore(initialGame: initialGame)
        store.send(.nextTurn)
        TestWait(testTimeout)
        XCTAssertEqual(store.game.board.fullMoves, 1)
        XCTAssertEqual(store.game.board.playingSide, .black)
        store.send(.nextTurn)
        TestWait(testTimeout)
        XCTAssertEqual(store.game.board.fullMoves, 2)
        XCTAssertEqual(store.game.board.playingSide, .white)
        store.send(.nextTurn)
        TestWait(testTimeout)
        XCTAssertEqual(store.game.board.fullMoves, 2)
        XCTAssertEqual(store.game.board.playingSide, .black)
        store.send(.nextTurn)
        TestWait(testTimeout)
        XCTAssertEqual(store.game.board.fullMoves, 3)
        XCTAssertEqual(store.game.board.playingSide, .white)
        XCTAssertEqual(store.game.board.FEN, "rnbqkbnr/ppp2ppp/3p4/4p3/4P3/3P4/PPP2PPP/RNBQKBNR w KQkq - 0 3")
    }

    static var allTests = [
        ("testPlaybackBot", testPlaybackBot),
        ("testRandomBots", testRandomBots)
    ]
}
