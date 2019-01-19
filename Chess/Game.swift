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
        case paused
    }
    
    public class Game {
        internal var userPaused = false
        internal var botPausedMove: Chess.Move?
        var winningSide: Side? {
            didSet {
                if let winningSide = winningSide {
                    switch winningSide {
                    case .black:
                        pgn.result = .blackWon
                    case .white:
                        pgn.result = .whiteWon
                    }
                }
            }
        }
        var winner: Player? {
            guard let winningSide = winningSide else { return nil }
            return (winningSide == .black) ? black : white
        }
        let black: Player
        let white: Player
        var round: Int = 1
        var pgn: Chess.Game.PortableNotation
        var status: GameStatus {
            guard let lastMove = board.lastMove else {
                if board.FEN == Chess.Board.startingFEN {
                    return .notYetStarted
                }
                return .unknown
            }
            
            if userPaused {
                return .paused
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
        let board: Chess.Board
        public init(_ player: Player, against challenger: Player, ui: Chess_GameVisualizing = Chess.UI.Default.devNull) {
            self.board = Chess.Board(ui: ui)
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
            pgn = Chess.Game.PortableNotation(eventName: "Leela iOS Arena",
                                              site: PortableNotation.deviceSite(),
                                              date: Date(),
                                              round: round,
                                              black: black.pgnName,
                                              white: white.pgnName,
                                              result: .other,
                                              tags: [:],
                                              moves: [])
        }
        
        public func start() {
            userPaused = false
            executeTurn()
        }
        
        public func pause() {
            // TODO add bot check
            userPaused = true
        }
        
        internal func executeTurn() {
            if let move = botPausedMove {
                guard move.side == board.playingSide else {
                    fatalError("bot move cache corrupted.")
                }
                botPausedMove = nil
                execute(move: move)
                return
            }

            weak var weakSelf = self
            activePlayer?.getBestMove(currentFEN: board.FEN, movesSoFar: []) { move in
                guard let strongSelf = weakSelf else {
                    return
                }
                
                // Did the user pause while the bot was thinking?
                // TODO add bot check
                if strongSelf.userPaused {
                    strongSelf.botPausedMove = move
                    return
                }
                
                guard move.continuesGameplay else {
                    if move.isResign || move.isTimeout {
                        // TODO: do we push the resign onto [turns] and the UI stack as well here?
//                        strongSelf.board.lastMove = move
                        
                        strongSelf.winningSide = move.side.opposingSide
                        return
                    }

                    fatalError("Need to diagnose this scenario, shouldn't come here.")
                }
                strongSelf.execute(move: move)
            }
        }
        
        internal func execute(move: Chess.Move) {
            // Create a previous move "clear" ui event while we still have access to `lastMove`
            var lastUIClear: Chess.UI.Update? = nil
            if let lastMove = board.lastMove {
                lastUIClear = Chess.UI.Update.selection(Chess.UI.SelectionUpdate.selectionsCleared,
                                                         positions: [lastMove.start, lastMove.end])
            }
            let moveTry = board.attemptMove(move)
            switch moveTry {
            case .success(let capturedPiece):
                print("Moved: \(move)")
                let annotatedMove = Chess.Game.AnnotatedMove(side: move.side, move: move.PGN ?? "??", fenAfterMove: board.FEN, annotation: nil)
                pgn.moves.append(annotatedMove)
                // TODO: we may need to account for non-boardmoves
                if let clearSquares = lastUIClear {
                    // Clear the old move, and select the start of the new move.
                    board.ui.apply(board: board, updates: [clearSquares,
                            Chess.UI.Update.selection(Chess.UI.SelectionUpdate.isSelected, positions: [move.start])])
                }
                
                // we need to update the UI here
                // Note piece is at `move.end` now as the move is complete.
                if let piece = board.squares[move.end].piece {
                    let uiUpdate: Chess.UI.PieceUpdate
                    if let capturedPiece = capturedPiece {
                        uiUpdate = Chess.UI.PieceUpdate.capture(piece: piece.UI, from: move.start, captured: capturedPiece.UI, at: move.end)
                    } else {
                        uiUpdate = Chess.UI.PieceUpdate.moved(piece: piece.UI, from: move.start, to: move.end)
                    }
                    
                    var updates = [Chess.UI.Update.piece(uiUpdate)]
                    updates.append(Chess.UI.Update.selection(Chess.UI.SelectionUpdate.isSelected, positions: [move.start, move.end]))
                    switch move.sideEffect {
                    case .castling(let rookStart, let rookEnd):
                        if let rook = board.squares[rookEnd].piece {
                            let rookUpdate = Chess.UI.PieceUpdate.moved(piece: rook.UI, from: rookStart, to: rookEnd)
                            updates.append( Chess.UI.Update.piece(rookUpdate) )
                        }
                    case .enPassantCapture(_, _),  .enPassantInvade(_, _), .promotion(_), .notKnown, .simulating, .noneish:
                        // These cases don't imply another uiUpdate is needed.
                        break
                    }
                    updates.append( Chess.UI.Update.ledger(move) )
                    
                    board.ui.apply(board: board, updates: updates)
                }
                
                continueBasedOnStatus()
            case .failed(reason: let reason):
                print("Move failed: \(move) \(reason)")
                // TODO message user
                winningSide = board.playingSide.opposingSide
                print("\nUnknown: \n\(pgn.formattedString)")
                break
            }

        }
        
        internal func continueBasedOnStatus() {
            switch status {
            case .active:
                print("FEN: \(board.FEN)")
                executeTurn()
            case .mate:
                winningSide = board.playingSide.opposingSide
                print("\nMate: \n\(pgn.formattedString)")
            default:
                break
            }
        }
    }
}
