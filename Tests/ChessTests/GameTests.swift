import XCTest
import Combine
@testable import Chess

typealias GameTestMoveHandler = (Chess.Move) -> Void
class GameTestDelegate: ChessGameDelegate {
    let moveHandler: GameTestMoveHandler
    func gameAction(_ action: Chess.GameAction) {
        switch action {
        case .makeMove(let move):
            moveHandler(move)
        default:
            XCTFail("GameTestDelegate only expects moves.")
        }
    }
    init(_ moveHandler: @escaping GameTestMoveHandler) {
        self.moveHandler = moveHandler
    }
}

final class GameTests: XCTestCase {
    var store: ChessStore?
    var cancellables = Set<AnyCancellable>()
    func testGameSetup() {
        // The Chess robots are excersized more thoroughtly in their own tests, we play back a few moves here
        // to verify the basic game mechanics.
        var initialGame = Chess.Robot.playback(moves: [Chess.Move.white.e2.e4, Chess.Move.black.e7.e5])
        initialGame.setRobotPlaybackSpeed(0.2)
        initialGame.userPaused = false
        let store = ChessStore(game: initialGame)
        self.store = store
        let move1Expectation = expectation(description: "e2e4")
        var fen1: String? = "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1"
        let move2Expectation = expectation(description: "e7e5")
        var fen2: String? = "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2"
        // Setup our game test listener to see if the moves are completed
        self.store?.$game
            .sink(receiveValue: { testGame in
            let testFEN = testGame.board.FEN
            // Check if the first move has been completed.
            if testFEN == fen1 {
                fen1 = nil // So we don't match more than once.
                guard testGame.board.fullMoves == 1,
                      testGame.board.playingSide == .black else {
                    XCTFail("Move 1: The board isn't in the right state.")
                    return
                }
                move1Expectation.fulfill()
            }
            // Check if the second move has finished.
            if testFEN == fen2 {
                fen2 = nil // So we don't match more than once.
                guard testGame.board.fullMoves == 2,
                      testGame.board.playingSide == .white else {
                    XCTFail("Move 2: The board isn't in the right state.")
                    return
                }
                move2Expectation.fulfill()
            }
        }).store(in: &cancellables)
        self.store?.gameAction(.startGame)
        waitForExpectations(timeout: 10, handler: nil)
    }
    func testGameCheckmates() {
        // This test verifies the result of a game that should end in checkmate.
        var initialGame = Chess.Robot.playback(moves: [
            Chess.Move.white.e2.e4,
            Chess.Move.black.b8.c6,
            Chess.Move.white.f1.c4,
            Chess.Move.black.g7.g6,
            Chess.Move.white.d1.f3,
            Chess.Move.black.c6.d4,
            Chess.Move.white.f3.f7])
        initialGame.setRobotPlaybackSpeed(0.2)
        initialGame.userPaused = false
        let store = ChessStore(game: initialGame)
        self.store = store
        let mateExpectation = expectation(description: "f3f7")
        var mate: String? = "r1bqkbnr/pppppQ1p/6p1/8/2BnP3/8/PPPP1PPP/RNB1K1NR b KQkq - 0 4"
        // Setup our game test listener to see if the moves are completed
        self.store?.$game
            .sink(receiveValue: { testGame in
            let testFEN = testGame.board.FEN
            // Check if the first move has been completed.
            if testFEN == mate {
                mate = nil // So we don't match more than once.
                let status = testGame.computeGameStatus()
                guard status == .mate else {
                    XCTFail("Error: The board isn't in the right state.")
                    return
                }
                mateExpectation.fulfill()
            }
        }).store(in: &cancellables)
        self.store?.gameAction(.startGame)
        waitForExpectations(timeout: 10, handler: nil)
    }
    static var allTests = [
        ("testGameSetup", testGameSetup),
        ("testGameCheckmates", testGameCheckmates)
    ]
}
