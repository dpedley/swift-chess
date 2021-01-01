//
//  Board+Game.swift
//
//  Created by Douglas Pedley on 1/6/19.
//

import Foundation

/// Utility methods related to gameplay
public extension Chess.Board {
    func allSquaresAttacking(_ targetSquare: Chess.Square,
                             side: Chess.Side,
                             applyVariants: Bool) -> [Chess.Square] {
        var attackers: [Chess.Square] = []
        for square in squares {
            guard let piece = square.piece, piece.side == side else { continue }
            var attack = Chess.Move(side: side,
                                    start: square.position,
                                    end: targetSquare.position)
            var tmpBoard = Chess.Board(FEN: self.FEN)
            tmpBoard.playingSide = side
            let result = tmpBoard.attemptMove(&attack, applyVariants: applyVariants)
            switch result {
            case .success:
                attackers.append(square)
            default:
                break
            }
        }
        return attackers
    }
    func lastEnPassantPosition() -> Chess.Position? {
        guard let sideEffect = lastMove?.sideEffect else { return nil }
        switch sideEffect {
        case Chess.Move.SideEffect.enPassantInvade(let territory, _):
            return territory
        default:
            return nil
        }
    }
    func repetitionCount() -> Int {
        if let mostRepeated = repetitionMap.sorted(by: { $0.1 > $1.1 }).first {
            return mostRepeated.value
        }
        return 0
    }
    func hasMatingMaterial() -> Bool {
        // Walk the pieces to ensure mating material still exists.
        var position = 0
        var whiteGuards = 0
        var blackGuards = 0
        while position < 64 && blackGuards < 2 && whiteGuards < 2 {
            guard let piece = squares[position].piece else {
                position += 1
                continue
            }
            var matingValue = 0
            switch piece.pieceType {
            case .pawn, .rook, .queen:
                matingValue = 2
            case .knight, .bishop:
                matingValue = 1
            case .king:
                break
            }
            if piece.side == .black {
                blackGuards += matingValue
            } else {
                whiteGuards += matingValue
            }
            position += 1
        }
        if blackGuards < 2 && whiteGuards < 2 {
            return false
        }
        return true
    }
    func findKing(_ side: Chess.Side) -> Chess.Square {
        guard let square = findOptionalKing(side) else {
            fatalError("Tried to access the \(side) king when it wasn't on the board [\(FEN)]")
        }
        return square
    }
    internal func findOptionalKing(_ side: Chess.Side) -> Chess.Square? {
        var kingSearch: Chess.Square?
        squares.forEach {
            if let piece = $0.piece, piece.side == side {
                switch piece.pieceType {
                case .king:
                    kingSearch = $0
                default:
                    break
                }
            }
        }
        return kingSearch
    }
}
