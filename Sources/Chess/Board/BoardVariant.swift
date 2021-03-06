//
//  BoardVariant.swift
//
//  Created by Douglas Pedley on 1/9/19.
//
import Foundation

public extension Chess {
    enum BoardVariantError: Error {
        case noMoveToUndo
        case canOnlyUndoLastMove
    }
    class BoardVariant: NSObject {
        internal(set) public var originalFEN: String
        internal(set) public var changes: [Chess.Move] = []
        internal(set) public var board: Board
        public func pieceWeights() -> GameAnalysis {
            return board.pieceWeights()
        }
        public func makeMove(_ move: Chess.Move, deepVariant: Bool) throws {
            var moveAttempt = move
            let result = board.attemptMove(&moveAttempt, applyVariants: deepVariant)
            switch result {
            case .failure(let limitation):
                throw limitation
            case .success:
                changes.append(moveAttempt)
            }
        }
        public func undoMove(_ move: Chess.Move, deepVariant: Bool) throws {
            guard let lastMove = changes.last else {
                throw BoardVariantError.noMoveToUndo
            }
            guard lastMove == move else {
                throw BoardVariantError.canOnlyUndoLastMove
            }
            changes.removeLast()
            // Replay the change
            board.resetBoard(FEN: originalFEN)
            for change in changes {
                var moveAttempt = change
                // Note this assumption, undo is used primarily with
                // GameplayKit Strategist which wants the apply variants
                _ = board.attemptMove(&moveAttempt, applyVariants: deepVariant)
            }
        }
        public init(originalFEN: String) {
            self.originalFEN = originalFEN
            self.board = Board(FEN: originalFEN)
        }
        public init(originalBoard: Chess.Board) {
            self.board = originalBoard
            self.originalFEN = originalBoard.FEN
        }
    }
}
