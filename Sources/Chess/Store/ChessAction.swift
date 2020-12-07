//
//  ChessAction.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation

public enum ChessAction {
    case nextTurn
    case startGame
    case pauseGame
    case setBoard(fen: String)
    case makeMove(move: Chess.Move)
}

