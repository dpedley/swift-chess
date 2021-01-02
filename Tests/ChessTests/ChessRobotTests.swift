//
//  ChessRobotTests.swift
//  
import XCTest
import Combine
@testable import Chess

final class ChessRobotTests: XCTestCase {
    var store: ChessStore?
    var cancellables = Set<AnyCancellable>()
    func testPlaybackBot() {
        var game = Chess.Game.sampleGame()
        game.setRobotPlaybackSpeed(0.01)
        let store = ChessStore(game: game)
        let gameCompleted = expectation(description: "testPlaybackBot")
        var playbackCompleteFEN: String? = "8/8/4R1p1/2k3p1/1p4P1/1P1b1P2/3K1n2/8 b - - 2 43"
        store.$game.sink(receiveValue: { game in
            let testFEN = game.board.FEN
            guard testFEN == playbackCompleteFEN else { return }
            playbackCompleteFEN = nil
            gameCompleted.fulfill()
        }).store(in: &cancellables)
        store.gameAction(.startGame)
        self.store = store
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testGreedyBot() {
        let trickySpot = "5k2/3q2pB/6P1/6n1/8/2p5/3N4/3KR1R1 w - - 0 1"
        let board = Chess.Board(FEN: trickySpot)
        let notAFreePiece = Chess.Move.white.g1.g5
        let greedyBot = Chess.Robot.GreedyBot(side: .white)
        guard let greedyMove = greedyBot.evalutate(board: board) else {
            XCTFail("No move to evaluate.")
            return
        }
        XCTAssertTrue(notAFreePiece==greedyMove)
    }

    func testGreedyBots() {
        let white = Chess.Robot.GreedyBot(side: .white, stopAfterMove: 4)
        let black = Chess.Robot.GreedyBot(side: .black, stopAfterMove: 3)
        var game = Chess.Game(white, against: black)
        game.setRobotPlaybackSpeed(0.03)
        game.board.resetBoard(FEN: "1kr5/ppp5/r7/3q4/6p1/5P2/PPP1Q3/1KR4R w - - 0 1")
        let store = ChessStore(game: game)
        let wasGreedy = expectation(description: "testGreedyBot")
        var doubleQueenSac: String? = "1kr5/p1p5/p7/8/6P1/8/PPP5/1K5R b - - 0 3"
        store.$game.sink(receiveValue: { game in
            guard game.board.FEN == doubleQueenSac else { return }
            doubleQueenSac = nil
            wasGreedy.fulfill()
        }).store(in: &cancellables)
        store.gameAction(.startGame)
        self.store = store
        waitForExpectations(timeout: 30, handler: nil)
    }

    func testCautiousBot() {
        let youShouldTakeThePawn = "1r4k1/r1q2ppp/8/8/3R4/P3K3/1PP3R1/1Q6 b - - 0 1"
        let board = Chess.Board(FEN: youShouldTakeThePawn)
        let riskyTake = Chess.Move.black.a7.a3
        let cautiousBot = Chess.Robot.CautiousBot(side: .black)
        guard let cautiousMove = cautiousBot.evalutate(board: board) else {
            XCTFail("No move to evaluate.")
            return
        }
        XCTAssertFalse(cautiousMove==riskyTake)
    }

    func testCautiousBots() {
        let white = Chess.Robot.CautiousBot(side: .white, stopAfterMove: 3)
        let black = Chess.Robot.CautiousBot(side: .black, stopAfterMove: 2)
        var game = Chess.Game(white, against: black)
        game.setRobotPlaybackSpeed(0.03)
        game.board.resetBoard(FEN: "1k2r3/ppp1n3/8/1Pq2p1p/8/4RQ2/PPP3P1/1K6 b - - 0 1")
        let store = ChessStore(game: game)
        let wasCautious = expectation(description: "testCautiousBot")
        var pawnTrade: String? = "1k2r3/ppp1n3/8/1q3p1Q/8/4R3/PPP3P1/1K6 b - - 0 2"
        store.$game.sink(receiveValue: { game in
            guard let testTrade = pawnTrade,
                  testTrade == game.board.FEN else { return }
            pawnTrade = nil
            wasCautious.fulfill()
        }).store(in: &cancellables)
        store.gameAction(.startGame)
        self.store = store
        waitForExpectations(timeout: 10, handler: nil)
    }

    static var allTests = [
        ("testPlaybackBots", testPlaybackBot),
        ("testCautiousBot", testCautiousBot),
        ("testCautiousBots", testCautiousBots),
        ("testGreedyBot", testGreedyBot),
        ("testGreedyBots", testGreedyBots)
    ]
}
