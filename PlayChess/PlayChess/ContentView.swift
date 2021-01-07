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
    @AppStorage("welcomeMessage")
        var welcomeMessage: Bool = true
    func welcomeView() -> some View {
        guard welcomeMessage else {
            return AnyView(EmptyView())
        }
        return AnyView(WelcomeView())
    }
    static let kingFlashColor = Color.yellow.opacity(0.2)
    func boardHighlightColor(_ game: Chess.Game) -> Color {
        guard game.kingFlash else { return .clear }
        Thread.detachNewThread {
            Thread.sleep(forTimeInterval: 0.2)
            store.gameAction(.kingFlash(active: false))
        }
        return Self.kingFlashColor
    }
    func newGameView(_ game: Chess.Game) -> NewGameView? {
        return store.game.board.turns.isEmpty ?
            NewGameView() : nil
    }
    func inProgressGameView(_ game: Chess.Game,
                            geometry: GeometryProxy) -> AnyView? {
        return store.game.board.turns.isEmpty ? nil :
            AnyView(
                HStack {
                    ChessLedgerView()
                        .frame(width: geometry.size.width / 2)
                    VStack(spacing: 0) {
                        DungeonView(side: .white)
                        DungeonView(side: .black)
                    }
                    .frame(width: geometry.size.width / 2)
                }
            )
    }
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
                            height: geometry.size.width + (BoardGameView.playerHeight * 2) )
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
