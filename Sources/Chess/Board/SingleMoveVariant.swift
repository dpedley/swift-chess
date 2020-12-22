//
//  SingleMoveVariant.swift
//  
//
//  Created by Douglas Pedley on 12/21/20.
//

import Foundation

public extension Chess {
    class SingleMoveVariant: BoardVariant {
        var move: Move? {
            return changes.first
        }
        public required init(originalFEN: String, move: Chess.Move, deepVariant: Bool = true) {
            super.init(originalFEN: originalFEN)
            try? makeMove(move, deepVariant: deepVariant)
        }
    }
}
