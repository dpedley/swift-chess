//
//  DungeonView+Pieces.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/19/20.
//

import SwiftUI
import Chess

extension DungeonView {
    func groupPieces(_ game: Chess.Game) -> ([Chess.Piece], [Chess.Piece]) {
        let allPieces = side == .black ? game.blackDungeon : game.whiteDungeon
        var oppPieces = side == .black ? game.whiteDungeon : game.blackDungeon
        var uniquePieces: [Chess.Piece] = []
        var commonPieces: [Chess.Piece] = []
        for piece in allPieces {
            if let found = oppPieces.firstIndex(of: piece) {
                commonPieces.append(piece)
                oppPieces.remove(at: found)
            } else {
                uniquePieces.append(piece)
            }
        }
        return (uniquePieces, commonPieces)
    }
    func uniquePieces(_ game: Chess.Game) -> [Chess.Piece] {
        return groupPieces(game).0.sorted {
            $0.weight > $1.weight
        }
    }
    func piecesInCommon(_ game: Chess.Game) -> [Chess.Piece] {
        return groupPieces(game).1.sorted {
            $0.weight > $1.weight
        }
    }
}
