//
//  SquareTargeted.swift
//  
//
//  Created by Douglas Pedley on 12/16/20.
//

import SwiftUI

public struct SquareTargeted: View {
    @EnvironmentObject public var store: ChessStore
    let position: Chess.Position
    public var body: some View {
        guard store.environment.preferences.highlightChoices,
              store.game.board.squares[position].targetedBySelected else {
            return AnyView(EmptyView())
        }
        let selected = GeometryReader { geometry in
            Circle()
                .inset(by: geometry.size.width / 3)
                .fill(Self.chessChoiceHighlight)
        }
        return AnyView(selected)
    }
    static let chessChoiceHighlight = Color(.sRGB, red: 1.0, green: 0.0, blue: 0.0, opacity: 0.3)
    public init(_ idx: Int) {
        self.position = Chess.Position(idx)
    }
}
