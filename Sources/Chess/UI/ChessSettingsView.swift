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
                ChessOpponentSelector(player: random(store.game, side: .white))
                ChessOpponentSelector(player: greedy(store.game, side: .white))
                ChessOpponentSelector(player: cautious(store.game, side: .white))
                //ChessOpponentSelector(player: mindyMax(store.game, side: .white))
                //ChessOpponentSelector(player: montyCarlo(store.game, side: .white))
            }
            Section(header: Text("Black")) {
                ChessOpponentSelector(player: Chess.HumanPlayer(side: .black))
                ChessOpponentSelector(player: random(store.game, side: .black))
                ChessOpponentSelector(player: greedy(store.game, side: .black))
                ChessOpponentSelector(player: cautious(store.game, side: .black))
                //ChessOpponentSelector(player: mindyMax(store.game, side: .black))
                //ChessOpponentSelector(player: montyCarlo(store.game, side: .black))
            }
            Section(header: Text("Robot Move Delay \(String(format: "%#0.1#2f", robotDelay)) seconds")) {
                Slider(value: $robotDelay, in: 0.1...10,
                       step: 0.05,
                       onEditingChanged: { _ in
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
    func random(_ game: Chess.Game, side: Chess.Side) -> Chess.Robot {
        let robot = Chess.Robot(side: side)
        robot.responseDelay = game.robotPlaybackSpeed()
        return robot
    }
    func greedy(_ game: Chess.Game, side: Chess.Side) -> Chess.Robot {
        let robot = Chess.Robot.GreedyBot(side: side)
        robot.responseDelay = game.robotPlaybackSpeed()
        return robot
    }
    func cautious(_ game: Chess.Game, side: Chess.Side) -> Chess.Robot {
        let robot = Chess.Robot.CautiousBot(side: side)
        robot.responseDelay = game.robotPlaybackSpeed()
        return robot
    }
    func mindyMax(_ game: Chess.Game, side: Chess.Side) -> Chess.Player {
        let robot = Chess.Robot.MindyMaxBot(side: side)
        return robot
    }
    func montyCarlo(_ game: Chess.Game, side: Chess.Side) -> Chess.Player {
        let robot = Chess.Robot.MontyCarloBot(side: side)
        return robot
    }
    public init() {}
}

struct ChessSettingsViewPreviews: PreviewProvider {
    static var previews: some View {
            ChessSettingsView()
                .environmentObject(previewChessStore)
    }
}
