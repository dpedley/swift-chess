//
//  ChessSettingsView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//

import Foundation
import SwiftUI

public struct ChessPlayerMenuView: View {
    @EnvironmentObject public var store: ChessStore
    public var body: some View {
        HStack {
            Menu("\(store.game.white.menuName())") {
                Button("Human") {
                    store.game.white = Chess.HumanPlayer(side: .white)
                }
                Button("RandomBot") {
                    store.game.white = Chess.Robot(side: .white)
                }
                Button("GreedyBot") {
                    store.game.white = Chess.Robot.GreedyBot(side: .white)
                }
                Button("CautiousBot") {
                    store.game.white = Chess.Robot.CautiousBot(side: .white)
                }
            }
            Button("< swap >") {
                guard store.game.userPaused else { return }
                let black = store.game.black
                let white = store.game.white
                store.game.black = white
                store.game.white = black
            }
            Menu("\(store.game.black.menuName())") {
                Button("Human") {
                    store.game.black = Chess.HumanPlayer(side: .black)
                }
                Button("RandomBot") {
                    store.game.black = Chess.Robot(side: .black)
                }
                Button("GreedyBot") {
                    store.game.black = Chess.Robot.GreedyBot(side: .black)
                }
                Button("CautiousBot") {
                    store.game.black = Chess.Robot.CautiousBot(side: .black)
                }
            }
        }
    }
}

public struct ChessSettingsView: View {
    @EnvironmentObject public var store: ChessStore
    public var body: some View {
        VStack {
            ChessPlayerMenuView()
                .environmentObject(store)
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
        }
    }
    public init() {}
}

struct ChessSettingsViewPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            Menu("Settings") {
                ChessSettingsView().environmentObject(previewChessStore)
            }
            Spacer()
            ChessSettingsView()
                .environmentObject(previewChessStore)
        }
    }
}
