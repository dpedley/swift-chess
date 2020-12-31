//
//  Move.swift
//
//  Created by Douglas Pedley on 1/5/19.
//

import Foundation

// swiftlint:disable nesting
public extension Chess {
    typealias MoveResult = Result<Chess.Piece?, Chess.Move.Limitation>
    struct Turn: Identifiable {
        public var white: Move?
        public var black: Move?
        // swiftlint:disable identifier_name
        public let id: Int
        init(_ id: Int, white: Move?, black: Move?) {
            self.id = id
            self.white = white
            self.black = black
        }
        // swiftlint:enable identifier_name
    }
    struct Move: Equatable {
        public static func == (lhs: Move, rhs: Move) -> Bool {
            return lhs.side == rhs.side && lhs.start == rhs.start && lhs.end == rhs.end
        }
        public enum Limitation: String, Error {
            case unknown = "Unknown limitation."
            case noPieceToMove = "The was no piece at the starting square."
            case notYourTurn = "The wrong side tried to move."
            case invalidAttackForPiece = "You cannot attack this way with this piece."
            case invalidMoveForPiece = "This piece doesn't move that way."
            case sameSideAlreadyOccupiesDestination = "Two pieces cannot occupy the same square."
            case kingWouldBeUnderAttackAfterMove = "You must save your king, piece is pinned."
        }
        // Core properties
        public let side: Chess.Side
        public let start: Chess.Position
        public let end: Chess.Position

        // Computed move constants
        public var unicodePGN: String? // THis is set when the move is committed.
        public var PGN: String? // THis is set when the move is committed.
        public let rankDistance: Int
        public let fileDistance: Int
        public let rankDirection: Int
        public let fileDirection: Int
        public var timeElapsed: TimeInterval?
        public var sideEffect: SideEffect
        public var isResign: Bool {
            return end.isResign
        }
        public var isTimeout: Bool {
            return end.isTimeout
        }
        public var continuesGameplay: Bool {
            return end.isBoardPosition
        }
        public var description: String {
            let desc: String
            if isResign {
                desc = "Resigned"
            } else if isTimeout {
                desc = "Ran out of time"
            } else if !continuesGameplay {
                Chess.log.critical("Cannot build a FEN unless this move continues gamesplay.")
                return "N/A"
            } else {
                let fens = "\(start.FEN)\(end.FEN)"
                if case SideEffect.promotion(let piece) = sideEffect {
                    desc = "\(fens)\(piece.fen())"
                } else {
                    desc = fens
                }
            }
            return desc
        }
        mutating func verify() {
            guard case .notKnown = sideEffect else { return }
            sideEffect = .verified
        }
        public init(side: Chess.Side,
                    start: Chess.Position,
                    end: Chess.Position,
                    sideEffect: Chess.Move.SideEffect = .notKnown,
                    ponderTime: TimeInterval? = nil) {
            self.side = side
            self.start = start
            self.end = end
            self.sideEffect = sideEffect
            self.timeElapsed = ponderTime
            guard !end.isResign else {
                self.rankDistance = 0
                self.fileDistance = 0
                self.rankDirection = 0
                self.fileDirection = 0
                return
            }
            self.rankDistance = start.rankDistance(from: end)
            self.fileDistance = start.fileDistance(from: end)
            self.rankDirection = (start.rank == end.rank) ? 0 : (start.rank < end.rank) ? 1 : -1
            self.fileDirection = (start.file == end.file) ? 0 : (start.file < end.file) ? 1 : -1
        }
    }
}
// swiftlint:enable nesting
