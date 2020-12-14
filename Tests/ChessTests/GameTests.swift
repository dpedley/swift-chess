import XCTest
import Combine
@testable import Chess

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

    static var allTests = [
        ("testGameSetup", testGameSetup)
    ]
}
