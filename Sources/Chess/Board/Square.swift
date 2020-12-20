//
//  BoardSquare.swift
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess {
    public struct Square {
        public let position: Position
        public var piece: Piece?
        public var isKingSide: Bool { return (position.fileNumber > 3) }
        public var isEmpty: Bool { return piece==nil }
        public var selected: Bool = false
        public var targetedBySelected: Bool = false
        public func attackedSquares(board: Chess.Board) -> [Square]? {
            guard let piece = piece else { return nil }
            var positions: [Square] = []
            for testIndex in 0..<board.squares.count {
                let testSquare = board.squares[testIndex]
                var moveTest = Move(side: piece.side,
                                    start: position,
                                    end: testSquare.position)
                if piece.isAttackValid(&moveTest) {
                    positions.append(testSquare)
                }
            }
            return positions.count > 0 ? positions : nil
        }
        private func validateSideEffects(_ move: Chess.Move, board: Chess.Board) -> Bool {
            switch move.sideEffect {
            case .verified, .notKnown, .enPassantCapture, .enPassantInvade, .promotion:
                return true
            case .castling(let rook, _):
                let kingStart: Chess.Position = move.side == .black ? .e8 : .e1
                let isKingSide: Bool = move.fileDirection > 0 ? true : false
                let validRook = Chess.Rules.startingPositionForRook(side: move.side, kingSide: isKingSide)
                guard move.start == kingStart,
                      rook == validRook else {
                    return false
                }
                return true
            }
        }
        public func buildMoveDestinations(board: Chess.Board) -> [Chess.Position]? {
            guard let piece = self.piece else { return nil }
            var destinations: [Chess.Position] = []
            for fenIndex in 0..<64 {
                let end = Chess.Position(fenIndex)
                guard end != position else { continue }
                var move = Chess.Move(side: piece.side,
                                      start: position,
                                      end: end)
                if piece.isAttackValid(&move) {
                    if validateSideEffects(move, board: board) {
                        destinations.append(end)
                    }
                } else if piece.pieceType.isPawn(), piece.isMoveValid(&move) {
                    if validateSideEffects(move, board: board) {
                        destinations.append(end)
                    }
                }
            }
            guard destinations.count>0 else { return nil }
            return destinations
        }
        public init(position: Position) {
            self.position = position
        }
        public mutating func clear() {
            self.piece = nil
        }
        public var description: String {
            return "\(position.FEN) \(piece?.FEN ?? "")"
        }
        func createCurrentFENString(_ emptyCount: inout Int) -> String {
            var fen = ""
            if let piece = piece {
                if emptyCount>0 {
                    fen += "\(emptyCount)"
                    emptyCount = 0
                }
                fen += piece.FEN
            } else {
                emptyCount+=1
            }
            // Check if we're in the last file for this rank
            if position.file=="h" {
                if emptyCount>0 {
                    fen += "\(emptyCount)"
                    emptyCount = 0
                }
                // No slash after the final rank
                if position.rank>1 {
                    fen += "/"
                }
            }
            return fen
        }
    }
}
