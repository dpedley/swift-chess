//
//  File.swift
//  
//
//  Created by Douglas Pedley on 12/16/20.
//
import Foundation
import SwiftUI

public struct PlayPauseButton: View {
    @EnvironmentObject public var store: ChessStore
    public var body: some View {
        Button {
            if store.game.userPaused {
                store.gameAction(.startGame)
            } else {
                store.gameAction(.pauseGame)
            }
        } label: { () -> AnyView in
            let image: Image
            if store.game.userPaused {
                // We don't show the play button if it's the user's turn
                guard store.game.activePlayer.isBot() else {
                    return AnyView(EmptyView())
                }
                image = Image(systemName: "play.circle")
            } else {
                // The game is playing, we only show the pause button if both sides are bots.
                guard store.game.white.isBot(), store.game.black.isBot() else {
                    return AnyView(EmptyView())
                }
                image = Image(systemName: "pause.circle")
            }
            return AnyView(image.foregroundColor(.black))
        }
    }
    public init() {}
}
