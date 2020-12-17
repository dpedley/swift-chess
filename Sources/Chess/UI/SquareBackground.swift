//
//  SquareBackground.swift
//  
//  Created by Douglas Pedley on 12/16/20.
//
import SwiftUI

public struct SquareBackground: View {
    @EnvironmentObject public var store: ChessStore
    let position: Chess.Position
    public var body: some View {
        Rectangle() // The square background
            .fill(color(store.environment.theme.color, for: position))
            .aspectRatio(1, contentMode: .fill)
    }
    public func color(_ themeColor: Chess.UI.BoardColor, for position: Chess.Position) -> Color {
        let evenSquare: Bool = (position.rank + position.fileNumber) % 2 == 0
        return evenSquare ? themeColor.dark : themeColor.light
    }
    public init(_ idx: Int) {
        self.position = Chess.Position(idx)
    }
}
