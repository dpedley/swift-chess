import XCTest
@testable import Chess

fileprivate let testTimeout: TimeInterval = 0.2

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

    func testPlaybackBot() {
        let initialGame = Chess.Game.sampleGame()
        let store = ChessStore(initialGame: initialGame)
        store.send(.startGame)
        TestWait(testTimeout * 40) // 60 moves per side?
        XCTAssertEqual(store.game.board.FEN, "8/8/4R1p1/2k3p1/1p4P1/1P1b1P2/3K1n2/8 b - - 0 43")
    }

    func testRandomBot() {
        let moveCount = 13
        let white = Chess.Robot.RandomBot(side: .white, stopAfterMove: moveCount)
        let black = Chess.Robot.RandomBot(side: .black, stopAfterMove: moveCount)
        let initialGame = Chess.Game(white, against: black)
        let store = ChessStore(initialGame: initialGame)
        store.send(.startGame)
        TestWait(testTimeout * Double(moveCount * 3))
        XCTAssertEqual(store.game.board.fullMoves, moveCount)
    }

    static var allTests = [
        ("testGameSetup", testGameSetup),
        ("testPlaybackBot", testPlaybackBot)
    ]
}
