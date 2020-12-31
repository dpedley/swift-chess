//
//  ChessSettingsView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//
import Foundation
import SwiftUI

public struct ChessSettingsButton: View {
    @EnvironmentObject public var store: ChessStore
    let action: () -> Void
    public var body: some View {
        Button(action: action, label: {
            Image(systemName: "gearshape")
                .foregroundColor(.primary)
        })
    }
    public init(_ action: @escaping () -> Void) {
        self.action = action
    }
}

public struct ChessSettingsView: View {
    public typealias DebugSectionProvider = () -> AnyView
    @EnvironmentObject public var store: ChessStore
    @State var robotDelay: TimeInterval = 1
    let debug: DebugSectionProvider
    func debugSettings(environment: ChessEnvironment) -> AnyView {
        guard environment.target == .development else {
            return AnyView(EmptyView())
        }
        return debug()
    }
    func index(_ side: Chess.Side, game: Chess.Game) -> Binding<Int> {
        return side == .black ?
            game.playerFactory.$black : game.playerFactory.$white
    }
    var availablePlayers: [String] = ["abc", "def"]
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Game")) {
                    Picker(selection: index(.white, game: store.game),
                           label: Text("White")) {
                        ForEach(0 ..< Chess.playerFactory.players.count) {
                            PlayerTitleView(player: Chess.playerFactory.players[$0](.white))
                        }
                    }
                    Picker(selection: index(.black, game: store.game),
                           label: Text("Black")) {
                        ForEach(0 ..< Chess.playerFactory.players.count) {
                            PlayerTitleView(player: Chess.playerFactory.players[$0](.black))
                        }
                    }
                }
                Section(header: Text("Colors")) {
                    BoardColorSelector(.brown)
                    BoardColorSelector(.blue)
                    BoardColorSelector(.green)
                    BoardColorSelector(.purple)
                }
                Section(header: Text("Highlights")) {
                    Toggle(isOn: $store.environment.preferences.highlightLastMove, label: {
                        Text("Show highlights for the last move")
                    })
                    Toggle(isOn: $store.environment.preferences.highlightChoices, label: {
                        Text("Show valid choices when moving")
                    })
                }
                debugSettings(environment: store.environment)
            }
            .navigationTitle("Settings")
            .accentColor(.primary)
        }
    }
    /*
    func playerChosenBlack() {
        var prevBot: Chess.Robot
        if let bot = store.game.black as? Chess.Robot {
            prevBot = bot
        } else {
            prevBot = Chess.Robot(side: .black)
            prevBot.responseDelay = store.game.robotPlaybackSpeed()
        }
        let player = Chess.playerFactory.players[defaultBlackIndex](.black)
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
            prevBot.responseDelay = store.game.robotPlaybackSpeed()
        }
        let player = Chess.playerFactory.players[defaultWhiteIndex](.white)
        store.game.white = player
        if !player.isBot() && !store.game.black.isBot() {
            // We don't allow 2 player game, make the other player a bot
            prevBot.side = .black
            store.game.black = prevBot
        }
    }*/
    public init(_ debug: DebugSectionProvider? = nil) {
        self.debug = debug ?? { AnyView(EmptyView()) }
    }
}

struct ChessSettingsViewPreviews: PreviewProvider {
    static var previews: some View {
            ChessSettingsView()
                .environmentObject(previewChessStore)
    }
}
