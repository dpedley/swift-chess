//
//  ChessOpponentSelector.swift
//  
//
//  Created by Douglas Pedley on 12/16/20.
//

import Foundation
import SwiftUI

public struct ChessOpponentSelector: View {
    @EnvironmentObject public var store: ChessStore
    let player: Chess.Player
    func playerChosen() {
        switch player.side {
        case .black:
            playerChosenBlack()
        case .white:
            playerChosenWhite()
            store.game.white = player
        }
    }
    func playerChosenBlack() {
        var prevBot: Chess.Robot
        if let bot = store.game.black as? Chess.Robot {
            prevBot = bot
        } else {
            prevBot = Chess.Robot(side: .black)
        }
        store.game.black = player
        if !player.isBot() && !store.game.white.isBot() {
            // We don't allow 2 player game, make the other player a bot
            prevBot.side = .white
            store.game.white = prevBot
        }
    }
    func playerChosenWhite() {
        var prevBot: Chess.Robot
        if let bot = store.game.white as? Chess.Robot {
            prevBot = bot
        } else {
            prevBot = Chess.Robot(side: .white)
        }
        store.game.white = player
        if !player.isBot() && !store.game.black.isBot() {
            // We don't allow 2 player game, make the other player a bot
            prevBot.side = .black
            store.game.black = prevBot
        }
    }
    func checkmarkView() -> some View {
        let storePlayer = player.side == .black ? store.game.black : store.game.white
        if storePlayer.menuName() == player.menuName() {
            let image = Image(systemName: "checkmark.circle.fill")
                .scaleEffect(1.5)
                .foregroundColor(.green)
            return AnyView(image)
        }
        return AnyView(EmptyView())
    }
    public var body: some View {
        HStack {
            Button(action: {
                playerChosen()
            }, label: {
                PlayerTitleView(player: player)
            })
            Spacer()
            checkmarkView()
        }
    }
    public init(player: Chess.Player) {
        self.player = player
    }
}
