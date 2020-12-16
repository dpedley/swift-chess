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
    enum Bot {
        case random
        case greedy
        case cautious
    }
    let player: Chess.Player
    func selectPlayer() {
        switch player.side {
        case .black:
            switchToBlack()
        case .white:
            switchToWhite()
            store.game.white = player
        }
    }
    func switchToBlack() {
        var prevBot: Chess.Robot
        if let bot = store.game.black as? Chess.Robot {
            prevBot = bot
        } else {
            prevBot = Chess.Robot(side: .black)
        }
        store.game.black = player
        if !store.game.white.isBot() {
            prevBot.side = .white
            store.game.white = prevBot
        }
    }
    func switchToWhite() {
        var prevBot: Chess.Robot
        if let bot = store.game.white as? Chess.Robot {
            prevBot = bot
        } else {
            prevBot = Chess.Robot(side: .white)
        }
        store.game.white = player
        if !store.game.black.isBot() {
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
                selectPlayer()
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
