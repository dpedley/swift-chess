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
        .black: Chess.HumanPlayer(side: .black),
        .white: Chess.HumanPlayer(side: .white)
    ]
    static let randomBot: [Chess.Side: Chess.Player] = [
        .black: Chess.Robot(side: .black),
        .white: Chess.Robot(side: .white)
    ]
    static let greedyBot: [Chess.Side: Chess.Player] = [
        .black: Chess.Robot.GreedyBot(side: .black),
        .white: Chess.Robot.GreedyBot(side: .white)
    ]
    static let cautiousBot: [Chess.Side: Chess.Player] = [
        .black: Chess.Robot.CautiousBot(side: .black),
        .white: Chess.Robot.CautiousBot(side: .white)
    ]
}

public struct ChessSettingsView: View {
    @EnvironmentObject public var store: ChessStore
    @State var playingAs: Int = 0 {
        didSet {
            switch playingAs {
            case 0:
                self.playerSelectedWhite()
            case 1:
                self.playerSelectedBlack()
            case 2:
                self.playerSelectedWatcher()
            default:
                break
            }
        }
    }
    public var body: some View {
        Form {
            Section(header: Text("Game Setup")) {
                Picker("Playing as", selection: self.$playingAs) {
                    HStack {
                        Image(systemName: ChessPlayers.human[.white]!.iconName())
                        Text("Play as white")
                            .tag(0)
                    }
                    HStack {
                        Image(systemName: ChessPlayers.human[.black]!.iconName())
                        Text("Play as black")
                            .tag(1)
                    }
                    HStack {
                        Image(systemName: "eyeglasses")
                        Text("Watch the bots play")
                            .tag(2)
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
            let robot: Chess.Robot = store.game.black as? Chess.Robot ?? Chess.Robot(side: .white)
            robot.side = .white
            store.game.white = robot
        }
        if !store.game.black.isBot() {
            let robot: Chess.Robot = store.game.white as? Chess.Robot ?? Chess.Robot(side: .black)
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
