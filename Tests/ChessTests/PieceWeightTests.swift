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
        
        for i in 1..<weights.count {
            let a = weights[i-1]
            let b = weights[i]
            XCTAssertEqual(a.value(for: .white), b.value(for: .white))
            XCTAssertTrue(a.value(for: .black) > b.value(for: .black))
        }
    }
    
    static var allTests = [
        ("testSideLosingPieces", testSideLosingPieces)
    ]
}

