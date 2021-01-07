//
//  ContentView+Game.swift
//  PlayChess
//
//  Created by Douglas Pedley on 1/6/21.
//

import SwiftUI
import Chess

extension ContentView {
    func welcomeView() -> WelcomeView? {
        return welcomeMessage ? WelcomeView() : nil
    }
    func newGameView(_ game: Chess.Game) -> NewGameView? {
        return store.game.board.turns.isEmpty ?
            NewGameView() : nil
    }
    func boardHighlightColor(_ game: Chess.Game) -> Color {
        guard game.kingFlash else { return .clear }
        // The flash is cleared a brief interval
        Thread.detachNewThread {
            Thread.sleep(forTimeInterval: 0.2)
            // We must clear it by rerouting through the store
            // to keep our UI thread from locking
            store.gameAction(.kingFlash(active: false))
        }
        return Color.yellow.opacity(0.2)
    }
    func inProgressGameView(_ game: Chess.Game,
                            geometry: GeometryProxy) -> AnyView? {
        return store.game.board.turns.isEmpty ? nil :
            AnyView(
                HStack {
                    ChessLedgerView()
                        .frame(width: geometry.size.width / 2)
                    VStack(spacing: 0) {
                        DungeonView(side: .white)
                        DungeonView(side: .black)
                    }
                    .frame(width: geometry.size.width / 2)
                }
            )
    }
}
