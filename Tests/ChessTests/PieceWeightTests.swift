import XCTest
@testable import Chess

final class PieceWeightTests: XCTestCase {
    func testSideLosingPieces() {
        var board = Chess.Board()
        board.resetBoard()
        var weights: [GameAnalysis] = []
        weights.append(board.pieceWeights())
        board.squares[0].piece = nil // Remove black rook
        weights.append(board.pieceWeights())
        board.squares[1].piece = nil // Remove black knight
        weights.append(board.pieceWeights())
        board.squares[2].piece = nil // Remove black bishop
        weights.append(board.pieceWeights())
        board.squares[3].piece = nil // Remove black queen
        weights.append(board.pieceWeights())
        board.squares[5].piece = nil // Remove black bishop
        weights.append(board.pieceWeights())
        board.squares[6].piece = nil // Remove black knight
        weights.append(board.pieceWeights())
        board.squares[7].piece = nil // Remove black rook
        weights.append(board.pieceWeights())
        for idx in 1..<weights.count {
            let first = weights[idx-1]
            let second = weights[idx]
            XCTAssertEqual(first.value(for: .white), second.value(for: .white))
            XCTAssertTrue(first.value(for: .black) > second.value(for: .black))
        }
    }
    static var allTests = [
        ("testSideLosingPieces", testSideLosingPieces)
    ]
}
