import XCTest
import Combine
@testable import Chess

final class GameTests: XCTestCase {
    var store: ChessStore?
    var cancellables = Set<AnyCancellable>()
    func testGameSetup() {
        // The Chess robots are excersized more thoroughtly in their own tests, we play back a few moves here
        // to verify the basic game mechanics.
        let game = Chess.Robot.playback(moves: [Chess.Move.white.e2.e4, Chess.Move.black.e7.e5])
        let store = ChessStore(game: game)
        self.store = store
        let move1Expectation = expectation(description: "e2e4")
        var fen1: String? = "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1"
        let move2Expectation = expectation(description: "e7e5")
        var fen2: String? = "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2"
        // Setup our game test listener to see if the moves are completed
        store.$game.sink(receiveValue: { game in
            let testFEN = game.board.FEN
            // Check if the first move has been completed.
            if testFEN == fen1 {
                fen1 = nil // So we don't match more than once.
                guard game.board.fullMoves == 1,
                      game.board.playingSide == .black else {
                    XCTFail("Move 1: The board isn't in the right state.")
                    return
                }
                move1Expectation.fulfill()
            }
            // Check if the second move has finished.
            if testFEN == fen2 {
                fen2 = nil // So we don't match more than once.
                guard game.board.fullMoves == 2,
                      game.board.playingSide == .white else {
                    XCTFail("Move 2: The board isn't in the right state.")
                    return
                }
                move2Expectation.fulfill()
            }
        }).store(in: &cancellables)
        store.send(.startGame)
        waitForExpectations(timeout: 10, handler: nil)
    }

    static var allTests = [
        ("testGameSetup", testGameSetup)
    ]
}
