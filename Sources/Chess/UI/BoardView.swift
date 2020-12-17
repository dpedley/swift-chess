//
//  BoardView.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/24/20.
//

import SwiftUI
import Combine

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

public struct BoardView: View {
    @EnvironmentObject public var store: ChessStore
    public let columns: [GridItem] = .init(repeating: .chessFile, count: 8)
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(0..<64) { idx in
                        ZStack {
                            SquareBackground(idx)
                            SquareMoveHighlight(idx)
                            SquareSelected(idx)
                            SquareTargeted(idx)
                            PieceView(position: idx)
                                .onDrag({ NSItemProvider(object: Chess.Position(idx).FEN as NSString) })
                        }
                        .onTapGesture {
                            store.gameAction(.userTappedSquare(position: idx))
                        }
                    }
                }
            }
            .frame(width: geometry.size.minimumLength,
                   height: geometry.size.minimumLength,
                   alignment: .center)
            .drawingGroup()
        }
    }
    public init() {}
}

struct BoardViewPreviews: PreviewProvider {
    static var previews: some View {
        HStack {
            BoardView().environmentObject(previewChessStore)
            // See ChessStore+Preview.swift for ^^ this
            VStack {
                Button("Green") {
                    previewChessStore.environmentChange(.boardColor(newColor: .green))
                }
                Button("Brown") {
                    previewChessStore.environmentChange(.boardColor(newColor: .brown))
                }
                Button("Blue") {
                    previewChessStore.environmentChange(.boardColor(newColor: .blue))
                }
                Button("Purple") {
                    previewChessStore.environmentChange(.boardColor(newColor: .purple))
                }
            }
        }
    }
}
