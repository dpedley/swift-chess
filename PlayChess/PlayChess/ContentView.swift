//
//  ContentView.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/9/20.
//

import SwiftUI
import Chess

struct ContentView: View {
    @EnvironmentObject var store: ChessStore
    @State var white: String = ""
    @State var black: String = ""
    var body: some View {
        VStack {
            Spacer()
            BoardView()
                .environmentObject(store)
            Spacer()
            HStack {
                Spacer()
                Menu("Board Color") {
                    Button("Green") {
                        store.environmentChange(.boardColor(newColor: .green))
                    }
                    Button("Blue") {
                        store.environmentChange(.boardColor(newColor: .blue))
                    }
                    Button("Brown") {
                        store.environmentChange(.boardColor(newColor: .brown))
                    }
                    Button("Purple") {
                        store.environmentChange(.boardColor(newColor: .purple))
                    }
                }
                Spacer()
            }
            Spacer(minLength: 50)
            HStack {
                Spacer()
                Menu("White \(white)") {
                    Button("Human") {
                        store.game.white = Chess.HumanPlayer(side: .white)
                        white = "Human"
                    }
                    Button("RandomBot") {
                        store.game.white = Chess.Robot(side: .white)
                        white = "RandomBot"
                    }
                    Button("GreedyBot") {
                        store.game.white = Chess.Robot.GreedyBot(side: .white)
                        white = "GreedyBot"
                    }
                    Button("CautiousBot") {
                        store.game.white = Chess.Robot.CautiousBot(side: .white)
                        white = "CautiousBot"
                    }
                }
                Spacer()
                Menu("Black \(black)") {
                    Button("Human") {
                        store.game.black = Chess.HumanPlayer(side: .black)
                        black = "Human"
                    }
                    Button("RandomBot") {
                        store.game.black = Chess.Robot(side: .black)
                        black = "RandomBot"
                    }
                    Button("GreedyBot") {
                        store.game.black = Chess.Robot.GreedyBot(side: .black)
                        black = "GreedyBot"
                    }
                    Button("CautiousBot") {
                        store.game.black = Chess.Robot.CautiousBot(side: .black)
                        black = "CautiousBot"
                    }
                }
                Spacer()
            }
            Spacer(minLength: 50)
            HStack {
                Spacer()
                Button("Reset Board") {
                    if !store.game.userPaused {
                        store.gameAction(.pauseGame)
                    }
                    store.gameAction(.resetBoard)
                }
                Spacer()
                Button("\(store.game.userPaused ? "Start" : "Pause")") {
                    store.game.setRobotPlaybackSpeed(1)
                    if store.game.userPaused {
                        store.game.userPaused = false
                        store.gameAction(.startGame)
                    } else {
                        store.gameAction(.pauseGame)
                    }
                }
                Spacer()
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let store = ChessStore()
    static var previews: some View {
        ContentView()
            .environmentObject(store)
    }
}
