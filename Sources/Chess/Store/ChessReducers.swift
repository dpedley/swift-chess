//
//  ChessReducer.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI
import Combine

public typealias ChessGameReducer = (Chess.Game, Chess.GameAction, ChessEnvironment,
                                     PassthroughSubject<Chess.Game, Never>) -> Void
public typealias ChessEnvironmentReducer = (ChessEnvironment, ChessEnvironment.EnvironmentChange,
                                     PassthroughSubject<ChessEnvironment, Never>) -> Void

public extension ChessStore {
    static func gameReducer(
        game: Chess.Game,
        action: Chess.GameAction,
        environment: ChessEnvironment,
        passThrough: PassthroughSubject<Chess.Game, Never>
    ) {
        var mutableGame = game
        switch action {
        case .nextTurn:
            Chess.log.info("nextTurn: \(game.board.playingSide)")
            mutableGame.nextTurn()
        case .startGame:
            Chess.log.info("startGame: Starting...")
            mutableGame.start()
        case .pauseGame:
            Chess.log.info("pauseGame: Pausing...")
            mutableGame.userPaused = true
        case .setBoard(let fen):
            Chess.log.info("setBoard: Board setup as: \(fen)")
            mutableGame.board.resetBoard(FEN: fen)
        case .resetBoard:
            Chess.log.info("resetBoard: resetting...")
            mutableGame.board.resetBoard(FEN: Chess.Board.startingFEN)
        case .makeMove(let move):
            Chess.log.info("makeMove: \(move.side) \(move.description)")
            mutableGame.execute(move: move)
            if mutableGame.board.lastMove == move {
                mutableGame.changeSides(move.side.opposingSide)
            }
        case .userTappedSquare(let position):
            Chess.log.info("userTappedSquare: \(position)")
            mutableGame.board.squares[position].selected.toggle()
            
            if mutableGame.board.squares[position].selected {
                if let targetedPositions = mutableGame.board.squares[position].buildMoveDestinations(board: mutableGame.board) {
                    targetedPositions.forEach {
                        mutableGame.board.squares[$0].targetedBySelected = true
                    }
                }
            } else {
                for i in 0..<64 {
                    mutableGame.board.squares[i].targetedBySelected = false
                }
            }
        }
        passThrough.send(mutableGame)
    }
}

public extension ChessStore {
    static func environmentReducer(
        environment: ChessEnvironment,
        change: ChessEnvironment.EnvironmentChange,
        passThrough: PassthroughSubject<ChessEnvironment, Never>
    ) {
        var mutableEnvironment = environment
        switch change {
        case .moveHighlight(let lastMove, let choices):
            Chess.log.info("moveHighlight preferences change: \(lastMove) \(choices)")
            mutableEnvironment.preferences.highlightLastMove = lastMove
            mutableEnvironment.preferences.highlightChoices = choices
        case .boardColor(let newColor):
            Chess.log.info("boardColor: \(newColor)...")
            mutableEnvironment.theme.color = newColor
        case .target(let newTarget):
            Chess.log.info("target environment: \(newTarget)...")
            mutableEnvironment.target = newTarget
        }
        passThrough.send(mutableEnvironment)
    }
}
