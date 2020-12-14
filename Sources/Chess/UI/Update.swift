//
//  Update.swift
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.UI {
    public enum PieceUpdate {
        case moved(piece: Chess.UI.Piece, start: Chess.Position, end: Chess.Position)
        case capture(piece: Chess.UI.Piece, start: Chess.Position, captured: Chess.UI.Piece, end: Chess.Position)
    }
    public enum Update {
        case clearSquare(_ squarePosition: Chess.Position)
        case flashSquare(_ squarePosition: Chess.Position)
        case piece(_ update: PieceUpdate)
        case highlight(_ positions: [Chess.Position])
        case deselect(_ selectionType: Chess.UI.Selection)
        case resetBoard(_ pieces: [Chess.UI.Piece])
        case ledger(_ move: Chess.Move)
    }
}
