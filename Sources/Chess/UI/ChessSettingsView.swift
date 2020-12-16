//
//  ChessSettingsView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//
import Foundation
import SwiftUI

public struct ChessSettingsView: View {
    @EnvironmentObject public var store: ChessStore
    @State var playingAs: PlayAsButton.Choice = .white
    public var body: some View {
        Form {
            Section(header: Text("Game Setup")) {
                HStack {
                    Text("Play")
                    Button(action: {
                        self.playingAs = .white
                        self.playerSelectedWhite()
                    }, label: {
                        PlayAsButton(.white, $playingAs)
                    })
                    Button(action: {
                        self.playingAs = .black
                        self.playerSelectedBlack()
                    }, label: {
                        PlayAsButton(.black, $playingAs)
                    })
                    Button(action: {
                        self.playingAs = .watch
                        self.playerSelectedWatcher()
                    }, label: {
                        PlayAsButton(.watch, $playingAs)
                    })
                }
                Toggle(isOn: $store.environment.preferences.highlightLastMove, label: {
                    Text("Show highlights for the last move")
                })
                Toggle(isOn: $store.environment.preferences.highlightChoices, label: {
                    Text("Show valid choices when moving")
                })
            }
            Section(header: Text("Robot Chess Opponents")) {
                ChessOpponentSelector(playingAs, bot: .random)
                    .environmentObject(store)
                ChessOpponentSelector(playingAs, bot: .greedy)
                    .environmentObject(store)
                ChessOpponentSelector(playingAs, bot: .cautious)
                    .environmentObject(store)
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
