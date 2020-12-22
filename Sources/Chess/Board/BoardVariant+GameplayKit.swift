//
//  BoardVariant+GameplayKit.swift
//  
//
//  Created by Douglas Pedley on 12/21/20.
//

import Foundation
import GameplayKit

extension Chess.BoardVariant: GKGameModel {
    static let blackModel = Chess.GameModelPlayer(0, side: .black)
    static let whiteModel = Chess.GameModelPlayer(1, side: .white)
    public var players: [GKGameModelPlayer]? {
        return [Self.blackModel, Self.whiteModel]
    }
    public var activePlayer: GKGameModelPlayer? {
        board.playingSide == .black ? Self.blackModel : Self.whiteModel
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
            guard $0.move != nil else { return nil }
            return Chess.GameModelUpdate($0)
        }
    }
    public func apply(_ gameModelUpdate: GKGameModelUpdate) {
        guard let update = gameModelUpdate as? Chess.GameModelUpdate,
              let move = update.variant.changes.last else {
            Chess.log.error("Couldn't apply GameplayKit update: \(gameModelUpdate)")
            return
        }
        do {
            try makeMove(move, deepVariant: true)
        } catch let error {
            Chess.log.error("GameModel apply move failed: \(error.localizedDescription)")
        }
    }
    public func unapplyGameModelUpdate(_ gameModelUpdate: GKGameModelUpdate) {
        guard let update = gameModelUpdate as? Chess.GameModelUpdate,
              let move = update.variant.changes.last else {
            Chess.log.error("Couldn't apply GameplayKit update: \(gameModelUpdate)")
            return
        }
        do {
            try undoMove(move, deepVariant: true)
        } catch let error {
            Chess.log.error("GameModel undo move failed: \(error.localizedDescription)")
        }
    }
    public func score(for player: GKGameModelPlayer) -> Int {
        guard let player = player as? Chess.GameModelPlayer else {
            fatalError("Misconfigured gameplaykit.")
        }
        let score = Int(board.pieceWeights().value(for: player.side) * 1000)
        return score
    }
    public func isWin(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? Chess.GameModelPlayer else {
            fatalError("Misconfigured gameplaykit.")
        }
        guard player.side == board.playingSide.opposingSide, board.isKingMated() else {
            return false
        }
        return true
    }
    public func isLoss(for player: GKGameModelPlayer) -> Bool {
        guard let player = player as? Chess.GameModelPlayer else {
            fatalError("Misconfigured gameplaykit.")
        }
        guard player.side == board.playingSide, board.isKingMated() else {
            return false
        }
        return true
    }
    public func copy(with zone: NSZone? = nil) -> Any {
        let copyBoard = Chess.BoardVariant(originalFEN: originalFEN)
        copyBoard.board = board
        copyBoard.changes = changes
        return copyBoard
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
        let variant: Chess.BoardVariant
        public var value: Int = 0
        public required init(_ variant: Chess.BoardVariant) {
            guard let move = variant.changes.last else {
                fatalError("Game model update assume at least one move.")
            }
            self.variant = variant
            guard let rollback = variant.copy() as? Chess.BoardVariant else { return }
            do {
                try rollback.undoMove(move, deepVariant: true)
                self.value = Self.evaluate(before: rollback, after: variant, side: move.side)
            } catch let error {
                Chess.log.error("GameModelUpdate: error rollback - \(error.localizedDescription)")
            }
        }
        static func evaluate(before: Chess.BoardVariant, after: Chess.BoardVariant, side: Chess.Side) -> Int {
            return Int(1000 * (after.pieceWeights().value(for: side) - before.pieceWeights().value(for: side)))
        }
    }
}
