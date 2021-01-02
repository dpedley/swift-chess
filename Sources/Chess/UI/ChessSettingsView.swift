//
//  ChessSettingsView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//
import Foundation
import SwiftUI

public struct BoardSegment: View {
    let color: Chess.UI.BoardColor
    public var body: some View {
        Text(color.id)
    }
}

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
    let colors = Chess.UI.BoardColor.allCases
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Players")) {
                    Picker(selection: $store.game.playerFactory.white,
                           label: Text("White")) {
                        ForEach(0 ..< Chess.playerFactory.players.count) {
                            PlayerTitleView(player: Chess.playerFactory.players[$0](.white))
                        }
                    }
                    .onChange(of: store.game.playerFactory.white) { _ in
                        self.playerChosenWhite()
                    }
                    Picker(selection: $store.game.playerFactory.black,
                           label: Text("Black")) {
                        ForEach(0 ..< Chess.playerFactory.players.count) {
                            PlayerTitleView(player: Chess.playerFactory.players[$0](.black))
                        }
                    }
                    .onChange(of: store.game.playerFactory.black) { _ in
                        self.playerChosenBlack()
                    }
                }
                Section(header: Text("Preferences")) {
                    Picker(selection: $store.environment.theme.color,
                           label: Text(store.environment.theme.color.id)) {
                        Text("Brown").tag(Chess.UI.BoardColor.brown)
                        Text("Blue").tag(Chess.UI.BoardColor.blue)
                        Text("Green").tag(Chess.UI.BoardColor.green)
                        Text("Purple").tag(Chess.UI.BoardColor.purple)
                    }.pickerStyle(SegmentedPickerStyle())
                    GeometryReader { boardColorGeometry in
                        HStack {
                            Spacer().frame(width: 4)
                            BoardIconView(store.environment.theme.color,
                                          width: 12,
                                          height: 2)
                                .frame(width: boardColorGeometry.size.width,
                                       height: boardColorGeometry.size.width / 6)
                        }
                    }
                    .frame(height: 50, alignment: .center)
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
    func playerChosenBlack() {
        var prevBot: Chess.Robot
        if let bot = store.game.black as? Chess.Robot {
            prevBot = bot
        } else {
            prevBot = Chess.Robot(side: .black)
            prevBot.responseDelay = store.game.robotPlaybackSpeed()
        }
        let blackIndex = store.game.playerFactory.black
        let player = Chess.playerFactory.players[blackIndex](.black)
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
        let whiteIndex = store.game.playerFactory.white
        let player = Chess.playerFactory.players[whiteIndex](.white)
        store.game.white = player
        if !player.isBot() && !store.game.black.isBot() {
            // We don't allow 2 player game, make the other player a bot
            prevBot.side = .black
            store.game.black = prevBot
        }
    }
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
