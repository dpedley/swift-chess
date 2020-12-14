//
//  BoardSquare.swift
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess {
    public struct Square {
        let position: Position
        var piece: Piece?
        var isKingSide: Bool { return (position.fileNumber > 3) }
        var isEmpty: Bool { return piece==nil }
        var selected: Bool = false
        var targetedBySelected: Bool = false
        func attackedSquares(board: Chess.Board) -> [Square]? {
            guard let piece = piece else { return nil }
            var positions: [Square] = []
            for testIndex in 0..<board.squares.count {
                let testSquare = board.squares[testIndex]
                var moveTest = Move(side: piece.side, start: position, end: testSquare.position)
                if piece.isAttackValid(&moveTest) {
                    positions.append(testSquare)
                }
            }
            return positions.count > 0 ? positions : nil
        }
        func buildMoveDestinations(board: Chess.Board) -> [Chess.Position]? {
            guard let piece = self.piece else { return nil }
            var destinations: [Chess.Position] = []
            for fenIndex in 0..<64 {
                let end = Chess.Position(fenIndex)
                guard end != position else { continue }
                var move = Chess.Move(side: piece.side, start: position, end: end)
                if piece.isMoveValid(&move) {
                    destinations.append(end)
                }
                if piece.pieceType.isPawn(), piece.isAttackValid(&move) {
                    destinations.append(end)
                }
            }
            guard destinations.count>0 else { return nil }
            return destinations
        }
        init(position: Position) {
            self.position = position
        }
        mutating func clear() {
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
