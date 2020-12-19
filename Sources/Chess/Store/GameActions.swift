//
//  ChessAction.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation

extension Chess {
    // Game actions cause changes to the game
    public enum GameAction {
        case nextTurn
        case startGame
        case pauseGame
        case resetBoard
        case setBoard(fen: String)
        case gameResult(result: Chess.Game.PGNResult, status: Chess.GameStatus)
        case makeMove(move: Chess.Move)
        case userTappedSquare(position: Chess.Position)
        case userDragged(position: Chess.Position)
        case userDropped(position: Chess.Position)
    }
    /// GameUpdate - used to inform of state changes created during gameplay processing
    public enum GameUpdate {
        case gameEnded(result: Chess.Game.PGNResult, status: Chess.GameStatus)
    }
}
