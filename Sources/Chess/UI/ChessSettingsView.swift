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
        Button (action: action, label: {
            Image(systemName: "gearshape.fill")
                .scaleEffect(1.5)
                .foregroundColor(.black)
        })
    }
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
}

public struct ChessSettingsView: View {
    @EnvironmentObject public var store: ChessStore
    @State var playingAs: PlayAsButton.Choice = .white
    public var body: some View {
        Form {
            Section(header: Text("White")) {
                ChessOpponentSelector(player: Chess.HumanPlayer(side: .white))
                ChessOpponentSelector(player: Chess.Robot(side: .white))
                ChessOpponentSelector(player: Chess.Robot.GreedyBot(side: .white))
                ChessOpponentSelector(player: Chess.Robot.CautiousBot(side: .white))
            }
            Section(header: Text("Black")) {
                ChessOpponentSelector(player: Chess.HumanPlayer(side: .black))
                ChessOpponentSelector(player: Chess.Robot(side: .black))
                ChessOpponentSelector(player: Chess.Robot.GreedyBot(side: .black))
                ChessOpponentSelector(player: Chess.Robot.CautiousBot(side: .black))
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
        }.foregroundColor(.black)
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
