//
//  Side+Move.swift
//  Leela
//
//  Created by Douglas Pedley on 1/17/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.Side {
    func twoSquareMove(fromString: String) -> Chess.Move? {
        if fromString.count != 4 {
            // Is this a promotion? eg. a2a1q
            guard fromString.count == 5,
                let promotingMove = twoSquareMove(fromString: String(fromString.dropLast()) ),
                let promotedPiece = Chess.Piece.from(fen: String(fromString.dropFirst(4))) else {
                    // We couldn't make a move
                    return nil
            }
            promotingMove.sideEffect = .promotion(piece: promotedPiece)
            print("Promoting \(fromString) \(promotingMove) \(promotedPiece)")
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
