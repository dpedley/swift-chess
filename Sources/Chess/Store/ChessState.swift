//
//  ChessState.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI
import Combine


struct ChessState {
    var player: Chess.Player
    var opponent: Chess.Player
    var game: Chess.Game
    var theme = Chess.UI.ChessTheme()
    init(player: Chess.Player? = nil, opponent: Chess.Player? = nil) {
        let player: Chess.Player = player ?? Chess.Player(side: .white, matchLength: 60)
        let opponent: Chess.Player = opponent ?? Chess.Player(side: player.side.opposingSide, matchLength: 60)
        self.player = player
        self.opponent = opponent
        self.game = Chess.Game(player, against: opponent)
    }
}
