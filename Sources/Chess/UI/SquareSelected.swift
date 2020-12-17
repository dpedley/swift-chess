//
//  SquareSelected.swift
//  
//
//  Created by Douglas Pedley on 12/16/20.
//

import SwiftUI

public struct SquareSelected: View {
    @EnvironmentObject public var store: ChessStore
    let position: Chess.Position
    public var body: some View {
        guard store.environment.preferences.highlightLastMove,
              store.game.board.squares[position].selected else {
            return AnyView(EmptyView())
        }
        let selected = Rectangle()
            .fill(SquareMoveHighlight.chessMoveHighlight)
            .aspectRatio(1, contentMode: .fill)
        return AnyView(selected)
    }
    public init(_ idx: Int) {
        self.position = Chess.Position(idx)
    }
}
