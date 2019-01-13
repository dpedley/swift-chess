//
//  BoardVariant.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/9/19.
//  Copyright © 2019 d0. All rights reserved.
//

import UIKit


extension Chess {
    
    enum BoardChange {
        case moveMade(move: Move)
        case moveFailed(move: Move, reason: Move.Limitation)
    }
    
    class BoardSimulation: Board {}
    
    class BoardVariant: NSObject {
        let originalFEN: String
        let changes: [BoardChange]
        let board: BoardSimulation
        init(originalFEN: String, changesToAttempt: [BoardChange]) {
            self.originalFEN = originalFEN
            board = BoardSimulation(FEN: originalFEN)
            var actualChanges: [BoardChange] = []
            for change in changesToAttempt {
                switch change {
                case .moveMade(let move):
                    let result = board.shallowAttemptMove(move)
                    switch result {
                    case .failed(let reason):
                        actualChanges.append(.moveFailed(move: move, reason: reason))
                    case .success(_): // piece
                        // Note about warning, we may want to include the piece loss for variant analysis styff here.
                        actualChanges.append(.moveMade(move: move))
                    }
                case .moveFailed:
                    // We just store these.
                    actualChanges.append(change)
                }
            }
            self.changes = actualChanges
        }        
    }
    
    class SingleMoveVariant: BoardVariant {
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
