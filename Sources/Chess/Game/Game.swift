//
//  Game.swift
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation
import Combine

public protocol ChessGameDelegate: AnyObject {
    func send(_ action: ChessAction)
}

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
    
    public struct Game: Identifiable {
        public let id = UUID()
        weak var delegate: ChessGameDelegate?
        internal var userPaused = true
        internal var botPausedMove: Chess.Move?
        var board = Chess.Board(populateExpensiveVisuals: true)
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
        var black: Player
        var white: Player
        var round: Int = 1
        var pgn: Chess.Game.PortableNotation
        var activePlayer: Player? {
            switch board.playingSide {
            case .white:
                return white
            case .black:
                return black
            }
        }
        public init(gameDelegate: ChessGameDelegate? = nil) {
            self.init(.init(side: .white, matchLength: 0), against: .init(side: .black, matchLength: 0), gameDelegate: gameDelegate)
        }
        public init(_ player: Player, against challenger: Player, gameDelegate: ChessGameDelegate? = nil) {
            self.delegate = gameDelegate
            guard player.side == challenger.side.opposingSide else {
                fatalError("Can't play with two \(player.side)s")
            }
            let white: Player
            let black: Player
            if player.side == .white {
                white = player
                black = challenger
            } else {
                black = player
                white = challenger
            }
            self.pgn = Chess.Game.PortableNotation(eventName: "Game \(Date())",
                                              site: PortableNotation.deviceSite(),
                                              date: Date(),
                                              round: 1,
                                              black: black.pgnName,
                                              white: white.pgnName,
                                              result: .other,
                                              tags: [:],
                                              moves: [])
            self.white = white
            self.black = black
            self.board.resetBoard()
        }
        
        public mutating func start() {
            userPaused = false
            nextTurn()
        }
        
        public mutating func pause() {
            // TODO add bot check
            userPaused = true
        }
        
        mutating internal func nextTurn() {
            guard let player = activePlayer else { return }
            player.turnUpdate(game: self)
        }
        
        mutating func execute(move: Chess.Move) {
            guard move.continuesGameplay else {
                if move.isResign || move.isTimeout {
                    // TODO: do we push the resign onto [turns] and the UI stack as well here?
//                        strongSelf.board.lastMove = move
                    winningSide = move.side.opposingSide
                    return
                }

                fatalError("Need to diagnose this scenario, shouldn't come here.")
            }
            // Create a mutable copy, moving may add side effects.
            var moveAttempt = move
            let moveTry = board.attemptMove(&moveAttempt)
            switch moveTry {
            case .success(let capturedPiece):
                let annotatedMove = Chess.Game.AnnotatedMove(side: move.side, move: move.PGN ?? "??", fenAfterMove: board.FEN, annotation: nil)
                pgn.moves.append(annotatedMove)
                // TODO: we may need to account for non-boardmoves
//                let clearPreviousMoves = Chess.UI.Update.deselect(.highlight)
//                board.ui.apply(board: board, updates: [clearPreviousMoves, Chess.UI.Update.highlight([move.start])])

                // we need to update the UI here
                // Note piece is at `move.end` now as the move is complete.
                if let piece = board.squares[move.end].piece {
                    let moveUpdate: Chess.UI.PieceUpdate
                    if let capturedPiece = capturedPiece {
                        moveUpdate = Chess.UI.PieceUpdate.capture(piece: piece.UI, from: move.start, captured: capturedPiece.UI, at: move.end)
                    } else {
                        moveUpdate = Chess.UI.PieceUpdate.moved(piece: piece.UI, from: move.start, to: move.end)
                    }
                    
                    // Update the board with the move
                    var updates = [Chess.UI.Update.piece(moveUpdate)]
                    updates.append(Chess.UI.Update.highlight([move.start, move.end]))
                    
                    // Add any side effects
                    switch move.sideEffect {
                    case .castling(let rookStart, let rookEnd):
                        if let rook = board.squares[rookEnd].piece {
                            let rookUpdate = Chess.UI.PieceUpdate.moved(piece: rook.UI, from: rookStart, to: rookEnd)
                            updates.append( Chess.UI.Update.piece(rookUpdate) )
                        }
                    case .enPassantCapture(_, _),  .enPassantInvade(_, _), .promotion(_), .notKnown, .noneish:
                        // These cases don't imply another uiUpdate is needed.
                        break
                    }
                    
                    // Check for check and mate
                    if board.squareForActiveKing.isUnderAttack(board: &board, attackingSide: board.playingSide) {
                        // Are we in mate?
                        switch status() {
                        case .mate:
                            break
                        case .unknown:
                            break
                        case .notYetStarted:
                            break
                        case .active:
                            break
                        case .resign:
                            break
                        case .timeout:
                            break
                        case .drawByRepetition:
                            break
                        case .drawByMoves:
                            break
                        case .drawBecauseOfInsufficientMatingMaterial:
                            break
                        case .stalemate:
                            break
                        case .paused:
                            break
                        }
                    }
                    // Lastly add this move to our ledger
                    updates.append( Chess.UI.Update.ledger(move) )
                }
                
                continueBasedOnStatus()
            case .failed(reason: let reason):
                print("Move failed: \(move) \(reason)")
                if let human = activePlayer as? Chess.HumanPlayer {
                    updateBoard(human: human, failed: move, with: reason)
                    
                    // Try again human.
                    continueBasedOnStatus()
                } else {
                    // a bot failed to move, for some this means resign
                    
                
                    // TODO message user
                    winningSide = board.playingSide.opposingSide
                    print("\nUnknown: \n\(pgn.formattedString)")
                }
            }

        }
        
        internal func clearActivePlayerSelections() {
            // TODO: Vet the use of the old UI update here.
//            let updates = [Chess.UI.Update.deselect(.premove), Chess.UI.Update.deselect(.target)]
//            board.ui.apply(board: board, updates: updates)
        }
        
        internal func flashKing() {
            // TODO: Vet the use of the old UI update here.
//            let kingPosition = board.squareForActiveKing.position
//            let updates = [Chess.UI.Update.flashSquare(kingPosition)]
//            board.ui.apply(board: board, updates: updates)
        }
        
        internal func updateBoard(human: Chess.HumanPlayer, failed move: Chess.Move, with reason: Chess.Move.Limitation) {
            clearActivePlayerSelections()
            switch reason {
            case .invalidAttackForPiece, .invalidMoveForPiece, .noPieceToMove, .sameSideAlreadyOccupiesDestination:
                // Nothing to see here, just humans
                break
            case .kingWouldBeUnderAttackAfterMove:
                flashKing()
                Chess.Sounds.Check.play()
            case .unknown:
                print("Human's move had unknown limitation.")
            }
        }
        
        internal mutating func continueBasedOnStatus() {
            switch status() {
            case .active:
                if !userPaused {
                    delegate?.send(.nextTurn)
                }
            case .mate:
                winningSide = board.playingSide.opposingSide
                print("\nMate: \n\(pgn.formattedString)")
            default:
                break
            }
        }
    }
}
