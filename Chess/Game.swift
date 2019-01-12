//
//  Game.swift
//  LeelaChessZero
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation


extension Chess {
    public enum GameStatus {
        case unknown
        case notYetStarted
        case active
        case mate
        case resign
        case timeout
        case drawByRepetition
        case drawByMoves
        case drawBecauseOfInsufficientMatingMaterial
        case stalemate
    }
    
    public class Game {
        var winningSide: Side?
        var winner: Player? {
            guard let winningSide = winningSide else { return nil }
            return (winningSide == .black) ? black : white
        }
        let black: Player
        let white: Player
        var status: GameStatus {
            guard let lastMove = board.lastMove else {
                if board.FEN == Chess.Board.startingFEN {
                    return .notYetStarted
                }
                return .unknown
            }
            if lastMove.isTimeout {
                return .timeout
            }
            
            if lastMove.isResign {
                return .resign
            }

            // Does the active side have any valid moves?
            guard let allMoveVariantBoards = board.createVariantsForEveryValidMove() else {
                return .stalemate
            }
            
            var isStuckInCheck = true
            // Check if all the variants leave the king still in check
            for boardVariant in allMoveVariantBoards {
                if isStuckInCheck {
                    // Pretend this variant one move forward is still the currect player so we can evaluate the king
                    if !boardVariant.board.squareForActiveKing.isUnderAttack {
                        isStuckInCheck = false
                    }
                }
            }
            
            if isStuckInCheck {
                return .mate
            }
            
            // TODO: draws...
//            case drawByRepetition
//            case drawByMoves
//            case drawBecauseOfInsufficientMatingMaterial

            return .active
        }
        var activePlayer: Player? {
            switch board.playingSide {
            case .white:
                return white
            case .black:
                return black
            }
        }
        let board = Board()
        public init(_ player: Player, against challenger: Player) {
            guard player.side == challenger.side.opposingSide else {
                fatalError("Can't play with two \(player.side)s")
            }
            if player.side == .white {
                self.white = player
                self.black = challenger
            } else {
                self.black = player
                self.white = challenger
            }
            board.resetBoard()
        }
        
        public func start() {
            executeTurn()
        }
        
        internal func executeTurn() {
            // TODO: track moves
            weak var weakSelf = self
            activePlayer?.getBestMove(currentFEN: board.FEN, movesSoFar: []) { move in
                guard let strongSelf = weakSelf else {
                    return
                }
                guard move.continuesGameplay else {
                    if move.isResign || move.isTimeout {
                        strongSelf.board.lastMove = move
                        strongSelf.winningSide = move.side.opposingSide
                        return
                    }

                    fatalError("Need to diagnose this scenario, shouldn't come here.")
                }
                
                let moveTry = strongSelf.board.attemptMove(move)
                switch moveTry {
                case .success:
                    print("Moved: \(move)")
                    strongSelf.board.lastMove = move
                    strongSelf.continueBasedOnStatus()
                case .failed(reason: let reason):
                    print("Move failed: \(move) \(reason)")
                    // TODO message user
                    break
                }
            }
        }
        
        internal func continueBasedOnStatus() {
            switch status {
            case .active:
                print("FEN: \(board.FEN)")
                executeTurn()
            case .mate:
                winningSide = board.playingSide.opposingSide
            default:
                break
            }
        }
    }
}
