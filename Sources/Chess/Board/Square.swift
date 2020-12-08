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
        var piece: Piece? = nil {
            willSet {
                // Note this order, deselect first to catch the attackedSquareIndices referred squares before clearing.
                if selected { selected = false }
                
                // We need to rebuild the attacked squares index list.
                self.cachesPositionsOfAttackedSquares = nil
            }
        }
        var isKingSide: Bool { return (position > 3) }
        var isEmpty: Bool { return piece==nil }
        var selected: Bool = false {
            didSet {
                // TODO: this needs to be done elsewhere.
                // Need to update the other squares that are attached by this one.
//                attackedSquares?.forEach( { $0.attackedBySelected = selected } )
            }
        }
        var attackedBySelected: Bool = false {
            didSet {
                // This may need to trigger other "can move" stuff based on pins etc.
            }
        }
        // Note these index numbers of 64 squares that can be potentially be moved to by the piece
        // occupying this space. It is based on being the only piece on the board, so the piece's path to this
        // other square aren't checked. In other words, it's the attackable squares if this piece were alone on the
        // board.
        private var cachesPositionsOfAttackedSquares: [Chess.Position]? = nil
        mutating func positionsOfAttackedSquares(board: Chess.Board) -> [Chess.Position] {
            guard let positions = cachesPositionsOfAttackedSquares else {
                // Need to build the positions
                guard let piece = piece else {
                    cachesPositionsOfAttackedSquares = []
                    return []
                }
                var positions: [Chess.Position] = []
                for testIndex in 0..<board.squares.count {
                    let testSquare = board.squares[testIndex]
                    var moveTest = Move(side: piece.side, start: position, end: testSquare.position)
                    if piece.isAttackValid(&moveTest) {
                        positions.append(testIndex)
                    }
                }
                cachesPositionsOfAttackedSquares = positions
                return positions
            }
            return positions
        }
        mutating func attackedSquares(board: Chess.Board) -> [Square]? {
            let positions = positionsOfAttackedSquares(board: board)
            guard !positions.isEmpty else { return nil }
            return positions.map { board.squares[$0] }
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
        
        mutating func clear()  {
            self.piece = nil
        }
        
        public var description: String {
            return "\(position.FEN) \(piece?.FEN ?? "")"
        }
    }
}
