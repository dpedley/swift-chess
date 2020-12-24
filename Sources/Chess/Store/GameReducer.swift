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
        case .setBoard(let FEN):
            Chess.log.info("setBoard: Board setup as: \(FEN)")
            resetBoard(FEN: FEN, game: &mutableGame)
        case .resetBoard:
            Chess.log.info("resetBoard: resetting...")
            resetBoard(FEN: Chess.Board.startingFEN, game: &mutableGame)
        case .gameResult(let result, let status):
            Chess.log.info("gameResult: \(result.rawValue)")
            mutableGame.pgn.result = result
            mutableGame.info = .gameEnded(result: result, status: status)
            mutableGame.userPaused = true
        case .makeMove(let move):
            Chess.log.info("makeMove: \(move.side) \(move.description)")
            makeMove(move, game: &mutableGame)
        case .userTappedSquare(let position):
            Chess.log.info("userTappedSquare: \(position)")
            userTappedSquare(position, game: &mutableGame)
        case .userDragged(let position):
            Chess.log.info("userDragged: \(position)")
            // Clear before the drag starts in case they've also selected a square by tapping
            mutableGame.clearActivePlayerSelections()
            userTappedSquare(position, game: &mutableGame)
        case .userDropped(let position):
            Chess.log.info("userDropped: \(position)")
            userTappedSquare(position, game: &mutableGame)
        }
        passThrough.send(mutableGame)
    }
    private static func resetBoard(FEN: String, game: inout Chess.Game) {
        game.pgn = Chess.Game.freshPGN(game.black, game.white)
        game.info = nil
        game.board.resetBoard(FEN: FEN)
        game.clearDungeons()
    }
    private static func makeMove(_ move: Chess.Move, game: inout Chess.Game) {
        game.execute(move: move)
        if game.board.lastMove == move {
            game.changeSides(move.side.opposingSide)
            if game.board.isInCheck == true {
                Chess.Sounds().check()
            }
        }
    }
    static func humanInitialTap(_ position: Chess.Position, game: inout Chess.Game, human: Chess.HumanPlayer) {
        game.clearActivePlayerSelections()
        human.initialPositionTapped = position
        game.board.squares[position].selected = true
        if let targetedPositions =
            game.board.squares[position].buildMoveDestinations(board: game.board) {
            targetedPositions.forEach {
                game.board.squares[$0].targetedBySelected = true
            }
        }
    }
    static func userTappedSquare(_ position: Chess.Position, game: inout Chess.Game) {
        guard let human = (game.white as? Chess.HumanPlayer) ?? (game.black as? Chess.HumanPlayer) else {
            return
        }
        if game.userPaused {
            game.start()
        }
        guard let moveStart = human.initialPositionTapped else {
            // Check if they have a piece at this position.
            guard let piece = game.board.squares[position].piece,
                  piece.side == human.side else {
                game.clearActivePlayerSelections()
                // The user's first tap is only valid for own pieces.
                return
            }
            // This was the first tap, setup the selection
            humanInitialTap(position, game: &game, human: human)
            return
        }
        // Check if they retapped the same square, and the original piece is available
        guard moveStart != position,
              let piece = game.board.squares[moveStart].piece else {
            game.clearActivePlayerSelections()
            return
        }
        // The move we think they are planning to make
        let move = Chess.Move(side: human.side, start: moveStart, end: position)
        // If they tap their own piece as move end, they either want to make that their
        // move start, deselecting the other piece they had started to move, or they
        // are premoving and they suspect that their own piece will not be at move end
        // when it is their turn.
        if let endPiece = game.board.squares[position].piece,
           endPiece.side == human.side {
            // The end spot is their own, let's see if it is a possible move
            if game.board.playingSide != human.side {
                var moveAttempt = move
                if piece.isAttackValid(&moveAttempt) {
                    // We think this is a premove
                    human.moveAttempt = move
                    game.clearActivePlayerSelections()
                    return
                }
            }
            // They were not intending to premove, let's deselect the
            // previous start and make this the new start.
            humanInitialTap(position, game: &game, human: human)
            return
        }
        human.moveAttempt = move
        game.clearActivePlayerSelections()
    }
}
