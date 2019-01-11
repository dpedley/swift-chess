//
//  BoardSquare.swift
//  LeelaChessZero
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess {
    class Square: NSObject {
        let position: Position
        weak var board: Chess_PieceCoordinating?
        var piece: Piece? = nil {
            willSet {
                // Note this order, deselect first to catch the attackedSquareIndices referred squares before clearing.
                if selected { selected = false }
                
                // We need to rebuild the attacked squares index list.
                self.attackedSquareIndices.removeAll()
            }
            didSet {
                // If we don't have a piece now, all the cascading "clearing" is done in willSet
                guard let piece = piece else { return }

                guard let board = board else {
                    fatalError("We cannot compute attacked indices without a board reference.")
                }
                for testIndex in 0..<board.squares.count {
                    let testSquare = board.squares[testIndex]
                    if piece.isAttackValid(Move(side: piece.side, start: position, end: testSquare.position)) {
                        // Only
                        attackedSquareIndices.append(testIndex)
                    }
                }
            }
        }
        var isEmpty: Bool { return piece==nil }
        var selected: Bool = false {
            didSet {
                // Need to update the other squares that are attached by this one.
                attackedSquares?.forEach( { $0.attackedBySelected = selected } )
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
        private var attackedSquareIndices: [Chess.Position] = []
        var attackedSquares: [Square]? {
            guard let board = board, !attackedSquareIndices.isEmpty else { return nil }
            return attackedSquareIndices.map { board.squares[$0] }
        }
        
        // Note this is a somewhat heavy computed var, grab a copy for multiple inline uses
        var allSquaresWithValidAttackingPieces: [Square] {
            let occupiedPositions = board?.positionsForOccupiedSquares ?? []
            let filteredSquares = board?.squares.filter({ attackingSquare -> Bool in
                guard let attackingPiece = attackingSquare.piece,
                    attackingPiece.side != piece?.side,
                    attackingSquare.attackedSquareIndices.contains(position) else {
                    return false
                }
                
                // Need to check the lines.
                let attack = Move(side: attackingPiece.side, start: attackingSquare.position, end: position)
                guard let attackPathSteps = attackingPiece.steps(for: attack) else {
                    // There are no steps, the attack is on!
                    return true
                }
                
//                print("Move: \(attack) \(attack.start)\(attack.end) generated \(attackPathSteps)")
                for step in attackPathSteps {
                    if occupiedPositions.contains(step) {
                        return false
                    }
                }

                return true
            })
            return filteredSquares ?? []
        }
        
        init(position: Position) {
            self.position = position
        }
        
        func clear()  {
            self.piece = nil
        }
        
        var isUnderAttack: Bool {
            return allSquaresWithValidAttackingPieces.count > 0
        }
        
        override var description: String {
            return "\(position.FEN) \(piece?.FEN ?? "")"
        }
    }
}
