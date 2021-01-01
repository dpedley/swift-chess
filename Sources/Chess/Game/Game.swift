//
//  Game.swift
//
//  Created by Douglas Pedley on 1/5/19.
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
        public var blackDungeon: [Chess.Piece] = [] // Captured white pieces
        public var whiteDungeon: [Chess.Piece] = []
        public var board = Chess.Board(populateExpensiveVisuals: true)
        public var black: Player
        public var white: Player
        public var round: Int = 1
        public var pgn: Chess.Game.PortableNotation
        public var info: GameUpdate?
        public var activePlayer: Player {
            switch board.playingSide {
            case .white:
                return white
            case .black:
                return black
            }
        }
        public var playerFactory = PlayerFactorySettings()
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
            self.pgn = Self.freshPGN(black, white)
            self.white = white
            self.black = black
            self.board.resetBoard()
        }
        static func freshPGN(_ blackPlayer: Chess.Player, _ whitePlayer: Chess.Player) -> Chess.Game.PortableNotation {
            Chess.Game.PortableNotation(eventName: "Game \(Date())",
                                              site: PortableNotation.deviceSite(),
                                              date: Date(),
                                              round: 1,
                                              black: blackPlayer.pgnName,
                                              white: whitePlayer.pgnName,
                                              result: .other,
                                              tags: [:],
                                              moves: [])
        }
        public mutating func start() {
            userPaused = false
            nextTurn()
        }
        public mutating func pause() {
            userPaused = true
        }
        public mutating func clearDungeons() {
            blackDungeon.removeAll()
            whiteDungeon.removeAll()
        }
        public mutating func nextTurn() {
            activePlayer.turnUpdate(game: self)
        }
        public mutating func changeSides(_ side: Chess.Side) {
            board.playingSide = side
        }
        public mutating func execute(move: Chess.Move) {
            guard move.continuesGameplay else {
                if move.isResign || move.isTimeout {
                    appendLedger(move, pieceType: .king, captureType: nil)
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
                executeSuccess(move: moveAttempt, capturedPiece: capturedPiece)
            case .failure(let limitation):
                Chess.log.critical("Move failed: \(limitation)")
                if let human = activePlayer as? Chess.HumanPlayer {
                    executeFailed(human: human, failed: moveAttempt, with: limitation)
                } else {
                    // a bot failed to move, for some this means resign
                    let winningSide = board.playingSide.opposingSide
                    pgn.result = winningSide == .black ? .blackWon : .whiteWon
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
            if let piece = capturedPiece {
                // The captured piece is thrown in the dungeon
                switch piece.side {
                case .black:
                    whiteDungeon.append(piece)
                case .white:
                    blackDungeon.append(piece)
                }
                Chess.Sounds().capture()
            } else {
                Chess.Sounds().move()
            }
            let annotatedMove = Chess.Game.AnnotatedMove(side: move.side,
                                                         move: move.PGN ?? "??",
                                                         fenAfterMove: board.FEN,
                                                         annotation: nil)
            pgn.moves.append(annotatedMove)
            let player: Chess.Player? = black.isBot() ? ( white.isBot() ? nil : white) : black
            if let human = player, human.side == move.side {
                clearActivePlayerSelections()
            }
            // Note piece is at `move.end` now as the move is complete.
            if let moved = board.squares[move.end].piece {
                // Lastly add this move to our ledger
                appendLedger(move, pieceType: moved.pieceType, captureType: capturedPiece?.pieceType)
            }
        }
        mutating public func appendLedger(_ move: Chess.Move,
                                          pieceType: Chess.PieceType,
                                          captureType: Chess.PieceType?) {
            if board.playingSide == .black {
                if board.turns.count == 0 {
                    // This should only happen in board variants.
                    board.turns.append(Chess.Turn(0, white: move, black: nil))
                } else {
                    // This is the usual black move follows white, so the turn exists in the stack.
                    board.turns[board.turns.count - 1].black = move
                }
                board.fullMoves += 1
            } else {
                let index = board.turns.count
                board.turns.append(Chess.Turn(index, white: move, black: nil))
            }
            if captureType != nil || pieceType == .pawn {
                board.fiftyMovesCount = 0
            } else {
                board.fiftyMovesCount += 1
            }
            let boardKey = board.squares.reduce("") { key, square -> String in
                guard let fen = square.piece?.FEN else {
                    return key + "-"
                }
                return key + fen
            }
            if let repCount = board.repetitionMap[boardKey] {
                board.repetitionMap[boardKey] = repCount + 1
            } else {
                board.repetitionMap[boardKey] = 1
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
        mutating public func executeFailed(human: Chess.HumanPlayer,
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
                Chess.Sounds().check()
            case .unknown:
                Chess.log.info("Human's move had unknown limitation.")
            }
        }
    }
}
