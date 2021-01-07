//
//  ChessLedgerView+Items.swift
//  PlayChess
//
//  Created by Douglas Pedley on 1/6/21.
//

import SwiftUI
import Chess

extension ChessLedgerView {
    struct LedgerMove: View {
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
    struct LedgerItem: View {
        let turn: Chess.Turn
        var body: some View {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    LedgerMove(turn: turn, side: .white)
                        .frame(width: geometry.size.width / 2,
                               height: geometry.size.height,
                               alignment: .center)
                    LedgerMove(turn: turn, side: .black)
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
}
