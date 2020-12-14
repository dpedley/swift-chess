//
//  ChessPlayerMenuView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//

import Foundation
import SwiftUI

public struct ChessPlayerMenuView: View {
    let iconStore = ChessStore() // Used to render piece icons
    @EnvironmentObject public var store: ChessStore
    public var body: some View {
        HStack {
            Menu {
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
            } label: {
                Image(systemName: "person")
                Text("\(store.game.white.menuName())")
            }
            Button {
                guard store.game.userPaused else { return }
                let black = store.game.black
                let white = store.game.white
                store.game.black = white
                store.game.white = black
            } label: {
                Image(systemName: "arrow.left.arrow.right.circle.fill")
            }
            Menu {
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
            } label: {
                Image(systemName: "person.fill")
                Text("\(store.game.black.menuName())")
            }
        }
    }
    public init() {}
}

struct ChessPlayerMenuViewPreviews: PreviewProvider {
    static var previews: some View {
        ChessPlayerMenuView().environmentObject(previewChessStore)
    }
}
