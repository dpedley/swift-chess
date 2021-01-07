//
//  BoardGameView+Players.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/16/20.
//

import SwiftUI
import Chess

extension BoardGameView {
    func topPlayer(_ game: Chess.Game) -> some View {
        // top and bottom are meant to allow white and black
        // to flip sides on the board.
        let player = game.black
        return PlayerTitleView(player: player)
    }
    func bottomPlayer(_ game: Chess.Game) -> some View {
        let player = game.white
        return PlayerTitleView(player: player)
    }
}

