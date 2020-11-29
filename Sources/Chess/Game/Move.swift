//
//  Move.swift
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess {
    struct Turn {
        var white: Move?
        var black: Move?
    }
    public class Move: NSObject {
        enum Limitation: String {
            case unknown = "Unknown limitation."
            case noPieceToMove = "The was no piece at the starting square."
            case invalidAttackForPiece = "You cannot attack this way with this piece."
            case invalidMoveForPiece = "This piece doesn't move that way."
            case piecePinned = "This piece is pinned, so it cannot move."
            case sameSideAlreadyOccupiesDestination = "Two pieces cannot occupy the same square."
            case kingWouldBeUnderAttackAfterMove = "You must save your king."
        }
        enum Result {
            case success(capturedPiece: Piece?)
            case failed(reason: Limitation)
        }
        
        // Core properties
        let side: Chess.Side
        let start: Chess.Position
        let end: Chess.Position
        
        // Computed move constants
        var unicodePGN: String? // THis is set when the move is committed.
        var PGN: String? // THis is set when the move is committed.
        let rankDistance: Int
        let fileDistance: Int
        let rankDirection: Int
        let fileDirection: Int
        
        var timeElapsed: TimeInterval?
        var sideEffect: SideEffect = .notKnown
        var isResign: Bool {
            return end.isResign
        }
        var isTimeout: Bool {
            return end.isTimeout
        }
        var continuesGameplay: Bool {
            return end.isBoardPosition
        }
        
        override public var description: String {
            let desc: String
            if isResign {
                desc = "Resigned"
            } else if isTimeout {
                desc = "Ran out of time"
            } else if !continuesGameplay {
                fatalError("Cannot build a FEN unless this move continues gamesplay.")
            } else {
                desc = "\(start.FEN)\(end.FEN)"
            }
            return desc
        }
        init(side: Chess.Side, start: Chess.Position, end: Chess.Position, ponderTime: TimeInterval? = nil) {
            self.side = side
            self.start = start
            self.end = end
            self.rankDistance = start.rankDistance(from: end)
            self.fileDistance = start.fileDistance(from: end)
            self.rankDirection = (start.rank == end.rank) ? 0 : (start.rank < end.rank) ? 1 : -1
            self.fileDirection = (start.file == end.file) ? 0 : (start.file < end.file) ? 1 : -1
            self.timeElapsed = ponderTime
        }
    }
}
