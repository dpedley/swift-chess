//
//  Side+Move.swift
//
//  Created by Douglas Pedley on 1/17/19.
//

import Foundation

public extension Chess.Side {
    func twoSquareMove(fromString: String) -> Chess.Move? {
        // First check for special moves
        if fromString == "O-O" { // Kingside castle
            switch self {
            case .black:
                return Chess.Move.black.O_O
            case .white:
                return Chess.Move.white.O_O
            }
        }

        if fromString == "O-O-O" { // Queenside castle
            switch self {
            case .black:
                return Chess.Move.black.O_O_O
            case .white:
                return Chess.Move.white.O_O_O
            }
        }

        if fromString.count != 4 {
            // Is this a promotion? eg. a2a1q
            guard fromString.count == 5,
                var promotingMove = twoSquareMove(fromString: String(fromString.dropLast()) ),
                let promotedPiece = Chess.Piece.from(fen: String(fromString.dropFirst(4))) else {
                    // We couldn't make a move
                    return nil
            }
            promotingMove.sideEffect = .promotion(piece: promotedPiece.pieceType)
            return promotingMove
        }
        let startPosition = String(fromString.dropLast(2))
        let endPosition = String(fromString.dropFirst(2))
        return Chess.Move(side: self,
                         start: Chess.Position.from(rankAndFile: startPosition),
                           end: Chess.Position.from(rankAndFile: endPosition))
    }

    func resigns(king: Chess.Position) -> Chess.Move {
        return Chess.Move(side: self, start: king, end: Chess.Position.resignedPosition)
    }

    func requestsBreak(king: Chess.Position) -> Chess.Move {
        return Chess.Move(side: self, start: king, end: Chess.Position.pausedPosition)
    }
}
