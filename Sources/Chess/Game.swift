//
//  Game.swift
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
    
    public class Game: ObservableObject {
        internal var userPaused = true
        internal var botPausedMove: Chess.Move?
        let board = Chess.Board()
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
            
            // Check for mate
            if board.findKing(board.playingSide).isUnderAttack {
                var isStuckInCheck = true
                if let allVariantBoards = board.createValidVariants(for: board.playingSide) {
                    for boardVariant in allVariantBoards {
                        if let kingSquare = boardVariant.board.findOptionalKing(board.playingSide), !kingSquare.isUnderAttack {
                            isStuckInCheck = false
                        }
                    }
                }
                if isStuckInCheck {
                    return .mate
                }
            }

            // Does the active side have any valid moves?
            guard board.validVariantExists(for: board.playingSide) else {
                return .stalemate
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
            pgn = Chess.Game.PortableNotation(eventName: "Game \(Date())",
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
                guard let strongSelf = weakSelf, let activePlayer = strongSelf.activePlayer else {
                    return
                }
                
                // If this callback was from a human, we don't want to be called twice so we nil it here
                if let human = activePlayer as? Chess.HumanPlayer {
                    human.chessBestMoveCallback = nil
                }
                
                // Did the user pause while the bot was thinking?
                // TODO add bot check
                if strongSelf.userPaused {
                    if activePlayer.isBot() {
                        strongSelf.botPausedMove = move
                    }
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
            let moveTry = board.attemptMove(move)
            switch moveTry {
            case .success(let capturedPiece):
                print("Moved: \(move)")
                let annotatedMove = Chess.Game.AnnotatedMove(side: move.side, move: move.PGN ?? "??", fenAfterMove: board.FEN, annotation: nil)
                pgn.moves.append(annotatedMove)
                // TODO: we may need to account for non-boardmoves
                let clearPreviousMoves = Chess.UI.Update.deselect(.highlight)
                #warning("Hookup UI")
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
                    case .enPassantCapture(_, _),  .enPassantInvade(_, _), .promotion(_), .notKnown, .simulating, .noneish:
                        // These cases don't imply another uiUpdate is needed.
                        break
                    }
                    
                    // Check for check and mate
                    if board.squareForActiveKing.isUnderAttack {
                        // Are we in mate?
                        switch status {
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
                    
                    #warning("Hookup UI")
//                    board.ui.apply(board: board, updates: updates)
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
            let updates = [Chess.UI.Update.deselect(.premove), Chess.UI.Update.deselect(.target)]
            #warning("Hookup UI")
//            board.ui.apply(board: board, updates: updates)
        }
        
        internal func flashKing() {
            let kingPosition = board.squareForActiveKing.position
            let updates = [Chess.UI.Update.flashSquare(kingPosition)]
            #warning("Hookup UI")
//            board.ui.apply(board: board, updates: updates)
        }
        
        internal func updateBoard(human: Chess.HumanPlayer, failed move: Chess.Move, with reason: Chess.Move.Limitation) {
            clearActivePlayerSelections()
            switch reason {
            case .invalidAttackForPiece, .invalidMoveForPiece, .noPieceToMove, .sameSideAlreadyOccupiesDestination:
                // Nothing to see here, just humans
                break
            case .piecePinned, .kingWouldBeUnderAttackAfterMove:
                flashKing()
                Chess.Sounds.Check.play()
            case .unknown:
                print("Human's move had unknown limitation.")
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
