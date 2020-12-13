//
//  BoardView.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/24/20.
//

import SwiftUI
import Combine

public struct BoardView: View {
    @EnvironmentObject public var store: ChessStore
    public let columns: [GridItem] = .init(repeating: .chessFile, count: 8)
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(0..<64) { idx in
                        ZStack {
                            Rectangle() // The square background
                                .fill(color(store.environment.theme.boardTheme.color, for: idx))
                                .aspectRatio(1, contentMode: .fill)
                            PieceView(position: idx)
                                .environmentObject(store)
                                .onDrag({ NSItemProvider(object: Chess.Position(idx).FEN as NSString) })
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
    public func color(_ themeColor: Chess.UI.BoardColor, for index: Int) -> Color {
        let evenSquare: Bool = (Chess.Position(index).rank + Chess.Position(index).fileNumber) % 2 == 0
        
        return evenSquare ? themeColor.dark : themeColor.light
    }
    public init() {}
}

struct BoardViewPreviews: PreviewProvider {
    static var previews: some View {
        HStack {
            BoardView().environmentObject(previewChessStore)
            // See ChessStore+Preview.swift for ^^ this
            Menu("Color") {
                Button("Green") {
                    previewChessStore.environment.theme.boardTheme.color = .green
                }
                Button("Brown") {
                    previewChessStore.environment.theme.boardTheme.color = .brown
                }
                Button("Blue") {
                    previewChessStore.environment.theme.boardTheme.color = .blue
                }
                Button("Purple") {
                    previewChessStore.environment.theme.boardTheme.color = .purple
                }
            }
        }
    }
}
