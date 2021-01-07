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
    @AppStorage("welcomeMessage") var welcomeMessage = true
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    Spacer()
                    ZStack {
                        BoardGameView()
                        Rectangle()
                            .fill(boardHighlightColor(store.game))
                    }.frame(width: geometry.size.width - 8,
                            height: geometry.size.width + 64 )
                    newGameView(store.game)
                    inProgressGameView(store.game, geometry: geometry)
                }
                .frame(width: geometry.size.width, alignment: .center)
                GameOverView($store.game.info)
                    .frame(width: geometry.size.width,
                           height: geometry.size.height,
                           alignment: .center)
                welcomeView()
                    .frame(width: geometry.size.width,
                           height: geometry.size.height,
                           alignment: .center)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let store: ChessStore = {
        let white = Chess.HumanPlayer(side: .white)
        let black = Chess.Robot.CautiousBot(side: .black)
        let game = Chess.Game(white, against: black)
        let store = ChessStore(game: game)
        return store
    }()
    static var previews: some View {
        ContentView()
            .environmentObject(store)
    }
}
