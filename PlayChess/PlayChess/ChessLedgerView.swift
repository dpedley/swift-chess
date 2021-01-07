//
//  ChessLedgerView.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/19/20.
//
import SwiftUI
import Chess

struct ChessLedgerMove: View {
    let turn: Chess.Turn
    let side: Chess.Side
    var move: Chess.Move? {
        side == .black ? turn.black : turn.white
    }
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Text("\(turn.id + 1)")
                    .font(.footnote)
                    .frame(width: 20,
                           height: geometry.size.height)
                    .border(side == .black ? Color.white : .black )
                    .foregroundColor(side == .black ? .white : .black )
                    .background(side == .black ? Color.black : .white )
                Text(move?.unicodePGN ?? "")
                    .bold()
                    .frame(width: geometry.size.width - 20,
                           height: geometry.size.height)
                    .background(Color(UIColor.secondarySystemBackground))
            }
            .frame(width: geometry.size.width)
        }
    }
}

struct ChessLedgerItem: View {
    let turn: Chess.Turn
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ChessLedgerMove(turn: turn, side: .white)
                    .frame(width: geometry.size.width / 2,
                           height: geometry.size.height,
                           alignment: .center)
                ChessLedgerMove(turn: turn, side: .black)
                    .frame(width: geometry.size.width / 2,
                           height: geometry.size.height,
                           alignment: .center)
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height,
                   alignment: .center)
        }
    }
}

struct ChessLedgerView: View {
    @EnvironmentObject var store: ChessStore
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 0) {
                ForEach(store.game.board.turns) { turn in
                    ChessLedgerItem(turn: turn)
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
