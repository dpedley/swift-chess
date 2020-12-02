import XCTest
@testable import Chess

fileprivate let testTimeout: TimeInterval = 0.25

final class GameTests: XCTestCase {
    func testGameSetup() {
        let initialGame = Chess.Robot.playback(moves: [Chess.Move.white.e2.e4, Chess.Move.black.e7.e5])
        let store = ChessStore(initialGame: initialGame)
        store.send(.nextTurn)
        TestWait(testTimeout)
        XCTAssertEqual(store.game.board.fullMoves, 1)
        XCTAssertEqual(store.game.board.FEN, "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
        store.send(.nextTurn)
        TestWait(testTimeout)
        XCTAssertEqual(store.game.board.fullMoves, 2)
        XCTAssertEqual(store.game.board.FEN, "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2")
    }

//    func testGamePlayback() {
//        let initialGame = Chess.Game.sampleGame()
//        let store = ChessStore(initialGame: initialGame)
//        store.send(.startGame)
//        TestWait(testTimeout * 120) // 60 moves per side?
//        XCTAssertEqual(store.game.board.FEN, "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1")
//    }

    static var allTests = [
        ("testGameSetup", testGameSetup),
    ]
}
