//
//  ChessLedgerView.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/19/20.
//
import SwiftUI
import Chess

struct ChessLedgerView: View {
    @EnvironmentObject var store: ChessStore
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 0) {
                ForEach(store.game.board.turns) { turn in
                    LedgerItem(turn: turn)
                        .frame(height: 32, alignment: .center)
                }
            }
            .border(Color.primary)
        }
    }
}

struct ChessLedgerViewPreview: PreviewProvider {
    static let ledger: ChessStore = {
        let white = Chess.HumanPlayer(side: .white)
        let black = Chess.HumanPlayer(side: .black)
        var game = Chess.Game(white, against: black)
        game.execute(move: Chess.Move.white.e2.e4)
        game.changeSides(.black)
        game.execute(move: Chess.Move.black.e7.e5)
        game.changeSides(.white)
        game.execute(move: Chess.Move.white.g1.f3)
        game.changeSides(.black)
        game.execute(move: Chess.Move.black.b8.c6)
        game.changeSides(.white)
        game.execute(move: Chess.Move.white.f1.b5)
        game.changeSides(.black)
        game.execute(move: Chess.Move.black.d8.f6)
        game.changeSides(.white)
        game.execute(move: Chess.Move.white.O_O)
        game.changeSides(.black)
        let store = ChessStore(game: game)
        store.game.userPaused = false
        return store
    }()
    static var previews: some View {
        let content = ContentView()
        content.welcomeMessage = false
        return content.environmentObject(ledger)
    }
}
