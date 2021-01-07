//
//  View+ChessHelpers.swift
//  PlayChess
//
//  Created by Douglas Pedley on 1/6/21.
//

import SwiftUI
import Chess

extension View {
    func findHuman(game: Chess.Game) -> Chess.HumanPlayer? {
        var human: Chess.HumanPlayer?
        if let player = game.black as? Chess.HumanPlayer {
            human = player
        } else if let player = game.white as? Chess.HumanPlayer {
            human = player
        }
        return human
    }
}
