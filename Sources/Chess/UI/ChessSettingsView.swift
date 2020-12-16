//
//  ChessSettingsView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//
import Foundation
import SwiftUI

public struct ChessPlayers {
    static let human: [Chess.Side: Chess.Player] = [
        .black : Chess.HumanPlayer(side: .black),
        .white : Chess.HumanPlayer(side: .white)
    ]
    static let randomBot: [Chess.Side: Chess.Player] = [
        .black : Chess.Robot(side: .black),
        .white : Chess.Robot(side: .white)
    ]
    static let greedyBot: [Chess.Side: Chess.Player] = [
        .black : Chess.Robot.GreedyBot(side: .black),
        .white : Chess.Robot.GreedyBot(side: .white)
    ]
    static let cautiousBot: [Chess.Side: Chess.Player] = [
        .black : Chess.Robot.CautiousBot(side: .black),
        .white : Chess.Robot.CautiousBot(side: .white)
    ]
}

public struct ChessSettingsView: View {
    enum SettingsPlayingAs: Int {
        case white = 0
        case black
        case watchingBotsPlay
    }
    @EnvironmentObject public var store: ChessStore
    @State var playingAs: SettingsPlayingAs = .white {
        didSet {
            switch playingAs {
            case .white:
                self.playerSelectedWhite()
            case .black:
                self.playerSelectedBlack()
            case .watchingBotsPlay:
                self.playerSelectedWatcher()
            }
        }
    }
    public var body: some View {
        Form {
            Section(header: Text("Game Setup")) {
                Picker("Playing as", selection: self.$playingAs) {
                    HStack {
                        Image(systemName: ChessPlayers.human[.white]!.iconName())
                        Text(ChessPlayers.human[.white]!.menuName())
                            .tag(SettingsPlayingAs.white.rawValue)
                    }
                    HStack {
                        Image(systemName: ChessPlayers.human[.black]!.iconName())
                        Text(ChessPlayers.human[.black]!.menuName())
                            .tag(SettingsPlayingAs.black.rawValue)
                    }
                    HStack {
                        Image(systemName: "eyeglasses")
                        Text("Watch the bots play")
                            .tag(SettingsPlayingAs.watchingBotsPlay.rawValue)
                    }
                }
                Toggle(isOn: $store.environment.preferences.highlightLastMove, label: {
                    Text("Show highlights for the last move")
                })
                Toggle(isOn: $store.environment.preferences.highlightChoices, label: {
                    Text("Show valid choices when moving")
                })
            }
        }
    }
    func playerSelectedWhite() {
        var robot = Chess.Robot(side: .black)
        if let black = store.game.black as? Chess.Robot {
            robot = black
        } else if let white = store.game.white as? Chess.Robot {
            robot = white
            robot.side = .black
        }
        store.game.white = Chess.HumanPlayer(side: .white)
        store.game.black = robot
    }
    func playerSelectedBlack() {
        var robot = Chess.Robot(side: .white)
        if let white = store.game.white as? Chess.Robot {
            robot = white
        } else if let black = store.game.black as? Chess.Robot {
            robot = black
            robot.side = .white
        }
        store.game.black = Chess.HumanPlayer(side: .black)
        store.game.white = robot
    }
    func playerSelectedWatcher() {
        if !store.game.white.isBot() {
            var robot: Chess.Robot = store.game.black as? Chess.Robot ?? Chess.Robot(side: .white)
            robot.side = .white
            store.game.white = robot
        }
        if !store.game.black.isBot() {
            var robot: Chess.Robot = store.game.white as? Chess.Robot ?? Chess.Robot(side: .black)
            robot.side = .black
            store.game.black = robot
        }
    }
    public init() {}
}

struct ChessSettingsViewPreviews: PreviewProvider {
    static var previews: some View {
            ChessSettingsView()
                .environmentObject(previewChessStore)
    }
}
