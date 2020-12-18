//
//  Game.swift
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation
import Combine

public protocol ChessGameDelegate: AnyObject {
    func gameAction(_ action: Chess.GameAction)
}

public extension Chess {
    struct Game {
        private var botPausedMove: Chess.Move?
        weak var delegate: ChessGameDelegate?
        public var userPaused = true
        public var board = Chess.Board(populateExpensiveVisuals: true)
        public var winningSide: Side? {
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
        public var winner: Player? {
            guard let winningSide = winningSide else { return nil }
            return (winningSide == .black) ? black : white
        }
        public var black: Player
        public var white: Player
        public var round: Int = 1
        public var pgn: Chess.Game.PortableNotation
        public var activePlayer: Player {
            switch board.playingSide {
            case .white:
                return white
            case .black:
                return black
            }
        }
        public init(gameDelegate: ChessGameDelegate? = nil) {
            self.init(.init(side: .white), against: .init(side: .black), gameDelegate: gameDelegate)
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
            userPaused = true
        }
        public mutating func nextTurn() {
            activePlayer.turnUpdate(game: self)
        }
        public mutating func changeSides(_ side: Chess.Side) {
            board.playingSide = side
            // STILL UNDONE: this is where the clock updates might happen
        }
        public mutating func execute(move: Chess.Move) {
            guard move.continuesGameplay else {
                if move.isResign || move.isTimeout {
                    // STILL UNDONE: do we push the resign onto [turns] and the UI stack as well here?
//                        strongSelf.board.lastMove = move
                    winningSide = move.side.opposingSide
                    return
                }
                Chess.log.critical("Need to diagnose this scenario, shouldn't come here.")
                return
            }
            // Create a mutable copy, moving may add side effects.
            var moveAttempt = move
            let moveTry = board.attemptMove(&moveAttempt)
            switch moveTry {
            case .success(let capturedPiece):
                executeSuccess(move: move, capturedPiece: capturedPiece)
            case .failure(let reason):
                Chess.log.debug("Move failed: \(move) \(reason)")
                if let human = activePlayer as? Chess.HumanPlayer {
                    updateBoard(human: human, failed: move, with: reason)
                } else {
                    // a bot failed to move, for some this means resign
                    // STILL UNDONE message user
                    winningSide = board.playingSide.opposingSide
                    Chess.log.debug("\nUnknown: \n\(pgn.formattedString)")
                }
            }
        }
        public mutating func setRobotPlaybackSpeed(_ responseDelay: TimeInterval) {
            if let white = white as? Chess.Robot {
                white.responseDelay = responseDelay
            }
            if let black = black as? Chess.Robot {
                black.responseDelay = responseDelay
            }
        }
        public func robotPlaybackSpeed() -> TimeInterval {
            if let white = white as? Chess.Robot {
                return white.responseDelay
            }
            if let black = black as? Chess.Robot {
                return black.responseDelay
            }
            return 1
        }
        mutating private func executeSuccess(move: Chess.Move, capturedPiece: Chess.Piece?) {
            let annotatedMove = Chess.Game.AnnotatedMove(side: move.side,
                                                         move: move.PGN ?? "??",
                                                         fenAfterMove: board.FEN,
                                                         annotation: nil)
            pgn.moves.append(annotatedMove)
            clearActivePlayerSelections()

            // we need to update the UI here
            // Note piece is at `move.end` now as the move is complete.
            if let piece = board.squares[move.end].piece {
                let moveUpdate: Chess.UI.PieceUpdate
                if let capturedPiece = capturedPiece {
                    moveUpdate = Chess.UI.PieceUpdate.capture(piece: piece.UI,
                                                              start: move.start,
                                                              captured: capturedPiece.UI,
                                                              end: move.end)
                } else {
                    moveUpdate = Chess.UI.PieceUpdate.moved(piece: piece.UI, start: move.start, end: move.end)
                }
                // Update the board with the move
                var updates = [Chess.UI.Update.piece(moveUpdate)]
                updates.append(Chess.UI.Update.highlight([move.start, move.end]))
                // Add any side effects
                switch move.sideEffect {
                case .castling(let rookStart, let rookEnd):
                    if let rook = board.squares[rookEnd].piece {
                        let rookUpdate = Chess.UI.PieceUpdate.moved(piece: rook.UI, start: rookStart, end: rookEnd)
                        updates.append( Chess.UI.Update.piece(rookUpdate) )
                    }
                case .enPassantCapture, .enPassantInvade, .promotion, .notKnown, .noneish:
                    // These cases don't imply another uiUpdate is needed.
                    break
                }
                // STILL UNDONE Check for check and mate and update game

                // Lastly add this move to our ledger
                updates.append(Chess.UI.Update.ledger(move))
                if board.playingSide == .black {
                    if board.turns.count == 0 {
                        // This should only happen in board variants.
                        board.turns.append(Chess.Turn(white: move, black: nil))
                    } else {
                        // This is the usual black move follows white, so the turn exists in the stack.
                        board.turns[board.turns.count - 1].black = move
                    }
                    board.fullMoves += 1
                } else {
                    board.turns.append(Chess.Turn(white: move, black: nil))
                }
            }
        }
        mutating public func clearActivePlayerSelections() {
            for idx in 0..<64 {
                board.squares[idx].selected = false
                board.squares[idx].targetedBySelected = false
            }
            if let human = black as? HumanPlayer {
                human.initialPositionTapped = nil
            }
            if let human = white as? HumanPlayer {
                human.initialPositionTapped = nil
            }
        }
        private func flashKing() {
            // STILL UNDONE: Vet the use of the old UI update here.
//            let kingPosition = board.squareForActiveKing.position
//            let updates = [Chess.UI.Update.flashSquare(kingPosition)]
//            board.ui.apply(board: board, updates: updates)
        }
        mutating public func updateBoard(human: Chess.HumanPlayer,
                                 failed move: Chess.Move,
                                 with reason: Chess.Move.Limitation) {
            clearActivePlayerSelections()
            switch reason {
            case .invalidAttackForPiece, .invalidMoveForPiece, .noPieceToMove,
                 .notYourTurn, .sameSideAlreadyOccupiesDestination:
                // Nothing to see here, just humans
                break
            case .kingWouldBeUnderAttackAfterMove:
                flashKing()
                Chess.Sounds.Check.play()
            case .unknown:
                Chess.log.info("Human's move had unknown limitation.")
            }
        }
    }
}
