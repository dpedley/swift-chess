//
//  Side+Move.swift
//
//  Created by Douglas Pedley on 1/17/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.Side {
    func twoSquareMove(fromString: String) -> Chess.Move? {
        // First check for special moves
        if fromString == "O-O" { // Kingside castle
            let kingsPosition: Chess.Position
            let kingsDestination: Chess.Position
            switch self {
            case .black:
                kingsPosition = Chess.Board.Black.King.index
                kingsDestination = Chess.Board.Black.KingsSide.Knight.index
            case .white:
                kingsPosition = Chess.Board.White.King.index
                kingsDestination = Chess.Board.White.KingsSide.Knight.index
            }
            return Chess.Move(side: self, start: kingsPosition, end: kingsDestination)
        }
        
        if fromString == "O-O-O" { // Queenside castle
            let kingsPosition: Chess.Position
            let kingsDestination: Chess.Position
            switch self {
            case .black:
                kingsPosition = Chess.Board.Black.King.index
                kingsDestination = Chess.Board.Black.QueensSide.Bishop.index
            case .white:
                kingsPosition = Chess.Board.White.King.index
                kingsDestination = Chess.Board.White.QueensSide.Bishop.index
            }
            return Chess.Move(side: self, start: kingsPosition, end: kingsDestination)
        }
        

        if fromString.count != 4 {
            // Is this a promotion? eg. a2a1q
            guard fromString.count == 5,
                let promotingMove = twoSquareMove(fromString: String(fromString.dropLast()) ),
                let promotedPiece = Chess.Piece.from(fen: String(fromString.dropFirst(4))) else {
                    // We couldn't make a move
                    return nil
            }
            promotingMove.sideEffect = .promotion(piece: promotedPiece)
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
