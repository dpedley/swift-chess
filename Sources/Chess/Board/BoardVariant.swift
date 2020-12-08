//
//  BoardVariant.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/9/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess {
    
    enum BoardChange {
        case moveMade(move: Move)
        case moveFailed(move: Move, reason: Move.Limitation)
    }
        
    class BoardVariant: NSObject {
        let originalFEN: String
        let changes: [BoardChange]
        var board: Board
        init(originalFEN: String, changesToAttempt: [BoardChange], deepVariant: Bool) {
            self.originalFEN = originalFEN
            var board = Board(FEN: originalFEN)
            var actualChanges: [BoardChange] = []
            for change in changesToAttempt {
                switch change {
                case .moveMade(var move):
                    let result = board.attemptMove(&move, applyVariants: deepVariant)
                    switch result {
                    case .failed(let reason):
                        actualChanges.append(.moveFailed(move: move, reason: reason))
                    case .success:
                        // Note about warning, we may want to include the piece loss for variant analysis stuff here.
                        actualChanges.append(.moveMade(move: move))
                    }
                case .moveFailed:
                    // We just store these.
                    actualChanges.append(change)
                }
            }
            self.board = board
            self.changes = actualChanges
        }        
    }
    
    class SingleMoveVariant: BoardVariant {
        lazy var pieceWeights: GameAnalysis = {
            return board.pieceWeights()
        }()
        var move: Move? {
            guard let firstChange = changes.first,
                case .moveMade(let firstMove) = firstChange else {
                    return nil
            }
            return firstMove
        }
        var limitation: Move.Limitation? {
            guard let firstChange = changes.first,
                case .moveFailed(_, let reason) = firstChange else {
                    return nil
            }
            return reason
        }
    }
}
