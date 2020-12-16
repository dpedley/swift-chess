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
                .scaleEffect(1.5)
                .foregroundColor(.black)
        })
    }
    public init(_ action: @escaping () -> Void) {
        self.action = action
    }
}

public struct ChessSettingsView: View {
    @EnvironmentObject public var store: ChessStore
    @State var robotDelay: TimeInterval = 1
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
            Section(header: Text("Robot Move Delay \(robotDelay) seconds")) {
                Slider(value: $robotDelay, in: 0.1...10, onEditingChanged: { _ in
                    store.game.setRobotPlaybackSpeed(robotDelay)
                })
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
    public init() {}
}

struct ChessSettingsViewPreviews: PreviewProvider {
    static var previews: some View {
            ChessSettingsView()
                .environmentObject(previewChessStore)
    }
}
