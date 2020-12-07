//
//  ChessRobotTests.swift
//  
import XCTest
import Combine
@testable import Chess

fileprivate let testTimeout: TimeInterval = 0.25

final class ChessRobotTests: XCTestCase {
    var store: ChessStore? = nil
    var cancellables = Set<AnyCancellable>()
    func testRandomBots() {
        let moveCount = 13
        let white = Chess.Robot.RandomBot(side: .white, stopAfterMove: moveCount)
        let black = Chess.Robot.RandomBot(side: .black, stopAfterMove: moveCount)
        let initialGame = Chess.Game(white, against: black)
        let store = ChessStore(initialGame: initialGame)
        let gameCompleted = expectation(description: "testRandomBots")
        store.$game.sink(receiveValue: { game in
            guard game.board.fullMoves == moveCount else { return }
            gameCompleted.fulfill()
        }).store(in: &cancellables)
        store.send(.startGame)
        self.store = store
        waitForExpectations(timeout: 30, handler: nil)
    }


    func testPlaybackBot() {
        let initialGame = Chess.Game.sampleGame()
        let store = ChessStore(initialGame: initialGame)
        let gameCompleted = expectation(description: "testPlaybackBot")
        var fulfilled = false
        store.$game.sink(receiveValue: { game in
            guard game.board.FEN == "8/8/4R1p1/2k3p1/1p4P1/1P1b1P2/3K1n2/8 b - - 0 43", !fulfilled else { return }
            fulfilled = true
            gameCompleted.fulfill()
        }).store(in: &cancellables)
        store.send(.startGame)
        self.store = store
        waitForExpectations(timeout: 30, handler: nil)
    }

    static var allTests = [
        ("testPlaybackBot", testPlaybackBot),
        ("testRandomBots", testRandomBots)
    ]
}
