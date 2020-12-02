import XCTest
@testable import Chess

fileprivate let testTimeout: TimeInterval = 0.1

final class GameTests: XCTestCase {
    func testGameSetup() {
        let white = Chess.Robot.PlaybackBot(firstName: "Test", lastName: "One",
                                         side: .white, moves: ["e2e4", ""], responseDelay: testTimeout)
        let black = Chess.Robot.PlaybackBot(firstName: "Test", lastName: "Two",
                                         side: .black, moves: ["e7e5"], responseDelay: testTimeout)
        let initialGame = Chess.Game(white, against: black)
        let store = ChessStore(initialGame: initialGame)
        let wait = testTimeout * 5
        store.game.nextTurn()
        TestWait(wait)
        XCTAssertEqual(store.game.round, 1)
        XCTAssertEqual(store.game.board.FEN, "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
        store.game.nextTurn()
        TestWait(wait)
        XCTAssertEqual(store.game.round, 1)
        XCTAssertEqual(store.game.board.FEN, "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2")
    }

    static var allTests = [
        ("testGameSetup", testGameSetup),
    ]
}
