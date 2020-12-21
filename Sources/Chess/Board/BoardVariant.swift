//
//  BoardVariant.swift
//
//  Created by Douglas Pedley on 1/9/19.
//
import Foundation
import GameplayKit

public extension Chess {
    enum BoardVariantError: Error {
        case noMoveToUndo
        case canOnlyUndoLastMove
    }
    class BoardVariant: NSObject {
        private(set) public var originalFEN: String
        private(set) public var changes: [Chess.Move] = []
        private(set) public var board: Board
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
        public func undoMove(_ move: Chess.Move) throws {
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
                _ = board.attemptMove(&moveAttempt, applyVariants: true)
            }
        }
        public init(originalFEN: String, deepVariant: Bool) {
            self.originalFEN = originalFEN
            self.board = Board(FEN: originalFEN)
        }
    }
}

public extension Chess {
    class GameModelPlayer: NSObject, GKGameModelPlayer {
        public let playerId: Int
        public let side: Chess.Side
        public init(_ playerId: Int, side: Chess.Side) {
            self.playerId = playerId
            self.side = side
        }
    }
    class GameModelUpdate: NSObject, GKGameModelUpdate {
        let move: Chess.Move
        public var value: Int = 0
        public required init(_ move: Chess.Move) {
            self.move = move
        }
    }
}

extension Chess.BoardVariant: GKGameModel {
    static let black = Chess.GameModelPlayer(0, side: .black)
    static let white = Chess.GameModelPlayer(1, side: .white)
    public var players: [GKGameModelPlayer]? {
        return [Self.black, Self.white]
    }
    public var activePlayer: GKGameModelPlayer? {
        board.playingSide == .black ? Self.black : Self.white
    }
    public func setGameModel(_ gameModel: GKGameModel) {
        guard let model = gameModel as? Chess.BoardVariant else {
            Chess.log.error("Couldn't use the gameModel \(gameModel)")
            return
        }
        self.originalFEN = model.originalFEN
        self.board = model.board
        self.changes = model.changes
    }
    public func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        guard let player = player as? Chess.GameModelPlayer else { return nil }
        let variants = board.createValidVariants(for: player.side)
        return variants?.compactMap {
            guard let move = $0.move else { return nil }
            return Chess.GameModelUpdate(move)
        }
    }
    public func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard let update = gameModelUpdate as? Chess.GameModelUpdate else {
            Chess.log.error("Couldn't apply GameplayKit update: \(gameModelUpdate)")
            return
        }
        var moveAttempt = update.move
        _ = board.attemptMove(&moveAttempt)
    }
    public func copy(with zone: NSZone? = nil) -> Any {
        let copyBoard = Chess.BoardVariant(originalFEN: originalFEN, deepVariant: true)
        copyBoard.board = board
        copyBoard.changes = changes
        return copyBoard
    }
}
