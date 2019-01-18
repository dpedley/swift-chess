//
//  Update.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.UI {
    public enum PieceUpdate {
        case moved(piece: Chess.UI.Piece, from: Chess.Position, to: Chess.Position)
        case capture(piece: Chess.UI.Piece, from: Chess.Position, captured: Chess.UI.Piece, at: Chess.Position)
    }
    
    public enum SelectionUpdate {
        case isSelected
        case selectionsCleared
        case isAttackableBySelectedPeice
    }
    
    public enum Update {
        case clearSquare(_ squarePosition: Chess.Position)
        case piece(_ update: PieceUpdate)
        case selection(_ update: SelectionUpdate, positions: [Chess.Position])
        case resetBoard(_ pieces: [Chess.UI.Piece])
        case ledger(_ move: Chess.Move)
    }
}
