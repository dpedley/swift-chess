//
//  SquareMoveHighlight.swift
//  
//
//  Created by Douglas Pedley on 12/16/20.
//

import SwiftUI

public struct SquareMoveHighlight: View {
    @EnvironmentObject public var store: ChessStore
    let position: Chess.Position
    public var body: some View {
        guard store.environment.preferences.highlightLastMove,
              let move = store.game.board.lastMove else {
            return AnyView(EmptyView())
        }
        guard move.start == position
                || move.end == position else {
            return AnyView(EmptyView())
        }
        let highlight = Rectangle()
            .fill(Self.chessMoveHighlight)
            .aspectRatio(1, contentMode: .fill)
        return AnyView(highlight)
    }
    static let chessMoveHighlight = Color(.sRGB, red: 0.0, green: 0.1, blue: 0.9, opacity: 0.3)
    public init(_ idx: Int) {
        self.position = Chess.Position(idx)
    }
}
