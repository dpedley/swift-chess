import XCTest
@testable import Chess

final class RankAndFilesTests: XCTestCase {
    func testRanks() throws {
        XCTAssertEqual(Chess.Position.a2.rankDistance(from: Chess.Position.a4), 2)
        XCTAssertEqual(Chess.Position.e5.rank, 5)
        XCTAssertEqual(Chess.Move.white.a1.h8.rankDistance, 7)
        XCTAssertEqual(Chess.Move.white.h1.h8.rankDistance, 7)
        XCTAssertEqual(Chess.Move.white.c3.d5.rankDistance, 2)
    }

    func testFiles() throws {
        XCTAssertEqual(Chess.Position.a2.fileDistance(from: Chess.Position.a4), 0)
        XCTAssertEqual(Chess.Position.e5.fileNumber, 4)
        XCTAssertEqual(Chess.Move.white.a1.h8.fileDistance, 7)
        XCTAssertEqual(Chess.Move.white.h1.h8.fileDistance, 0)
        XCTAssertEqual(Chess.Move.white.c3.d5.fileDistance, 1)
    }

    static var allTests = [
        ("testRanks", testRanks),
        ("testFiles", testFiles)
    ]
}

