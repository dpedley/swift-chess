//
//  GameplayKit.swift
//  
//
//  Created by Douglas Pedley on 12/21/20.
//
import XCTest
import Combine
@testable import Chess
//import GameplayKit

final class GameplayKitTests: XCTestCase {
    var store: ChessStore?
    var cancellables = Set<AnyCancellable>()
    var test: GameTestDelegate?
    var testGame: Chess.Game?
    func testMindyMaxBot() {
        /*
        let youShouldTakeTheRook = "6k1/r1q2ppp/8/8/8/P1P3R1/1P2R3/1Q2K3 b - - 0 1"
        let take = Chess.Move.black.c7.g3
        let human = Chess.HumanPlayer(side: .white)
        let mindy = Chess.Robot.MindyMaxBot(side: .black)
        var game = Chess.Game(human, against: mindy)
        game.board.resetBoard(FEN: youShouldTakeTheRook)
        let gameCompleted = expectation(description: "testMindyMaxBot")
        let delegate = GameTestDelegate { move in
            XCTAssertTrue(move==take, "Expected \(take.description) got \(move.description)")
            gameCompleted.fulfill()
        }
        game.delegate = delegate
        testGame = game
        test = delegate
        game.nextTurn()
        waitForExpectations(timeout: 10, handler: nil)
 */
    }
    func testMontyCarloBot() {
        /*
        let youShouldTakeThePawn = "1r4k1/r1q2ppp/8/8/3R4/P3K3/1PP3R1/1Q6 b - - 0 1"
        let riskyTake = Chess.Move.black.a7.a3
        let human = Chess.HumanPlayer(side: .white)
        let monty = Chess.Robot.MontyCarloBot(side: .black)
        var game = Chess.Game(human, against: monty)
        game.board.resetBoard(FEN: youShouldTakeThePawn)
        let gameCompleted = expectation(description: "testMontyCarloBot")
        let delegate = GameTestDelegate { move in
            XCTAssertTrue(move==riskyTake)
            gameCompleted.fulfill()
        }
        game.delegate = delegate
        testGame = game
        test = delegate
        game.nextTurn()
        waitForExpectations(timeout: 120, handler: nil)
 */
    }
    static var allTests = [
        ("testMindyMaxBot", testMindyMaxBot),
        ("testMontyCarloBot", testMontyCarloBot)
    ]
}
