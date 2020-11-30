import XCTest
@testable import Chess

fileprivate let testTimeout: TimeInterval = 0.1

final class GameTests: XCTestCase {
    func testGameSetup() {
        let white = Chess.PlaybackPlayer(firstName: "Test", lastName: "One",
                                         side: .white, moves: ["e2e4", ""], responseDelay: testTimeout)
        let black = Chess.PlaybackPlayer(firstName: "Test", lastName: "Two",
                                         side: .black, moves: ["e7e5"], responseDelay: testTimeout)
        let game = Chess.Game(white, against: black)
        let wait = testTimeout * 2
        game.board.resetBoard()
        game.nextTurn()
        TestWait(wait)
        XCTAssertEqual(game.round, 1)
        XCTAssertEqual(game.board.FEN, "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
        game.nextTurn()
        TestWait(wait)
        XCTAssertEqual(game.round, 1)
        XCTAssertEqual(game.board.FEN, "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2")
    }

    static var allTests = [
        ("testGameSetup", testGameSetup),
    ]
}
