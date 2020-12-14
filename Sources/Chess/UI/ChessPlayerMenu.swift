//
//  ChessPlayerMenuView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//

import Foundation
import SwiftUI

public struct ChessPlayerChooser: View {
    @Binding var presentingChooser: Bool
    let side: Chess.Side
    @EnvironmentObject public var store: ChessStore
    public var body: some View {
        HStack {
            Button("Human") {
                setPlayer(Chess.HumanPlayer(side: side))
            }
            Button("RandomBot") {
                setPlayer(Chess.Robot(side: side))
            }
            Button("GreedyBot") {
                setPlayer(Chess.Robot.GreedyBot(side: side))
            }
            Button("CautiousBot") {
                setPlayer(Chess.Robot.CautiousBot(side: side))
            }
        }
    }
    func setPlayer(_ player: Chess.Player) {
        switch side {
        case .black:
            store.game.black = player
        case .white:
            store.game.white = player
        }
        presentingChooser = false
    }
    public init(_ presentingChooser: Binding<Bool>, side: Chess.Side) {
        self.side = side
        self._presentingChooser = presentingChooser
    }
}

public struct ChessPlayerMenu: View {
    @EnvironmentObject public var store: ChessStore
    @State var blackChooser: Bool = false
    @State var whiteChooser: Bool = false
    public var body: some View {
        HStack {
            Button {
                self.whiteChooser = true
            } label: {
                Image(systemName: store.game.white.iconName())
                Text("\(store.game.white.menuName())")
            }
            .sheet(isPresented: $whiteChooser) {
                ChessPlayerChooser(self.$whiteChooser, side: .white)
                    .environmentObject(store)
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
            Button {
                self.blackChooser = true
            } label: {
                Image(systemName: store.game.black.iconName())
                Text("\(store.game.black.menuName())")
            }
            .sheet(isPresented: $blackChooser) {
                ChessPlayerChooser(self.$blackChooser, side: .black)
                    .environmentObject(store)
            }
        }
    }
    public init() {}
}

struct ChessPlayerMenuViewPreviews: PreviewProvider {
    static var previews: some View {
        ChessPlayerMenu().environmentObject(previewChessStore)
    }
}
