//
//  BoardView.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/24/20.
//

import SwiftUI
import Combine

struct BoardView: View, Identifiable {
    let id = UUID()
    @EnvironmentObject var store: ChessStore
    let columns: [GridItem] = .init(repeating: .chessFile, count: 8)
    var themeColor: Chess.UI.BoardColor { store.theme.boardTheme.color }
    func color(for index: Int) -> Color {
        return (Chess.Position(index).rank + Chess.Position(index).fileNumber) % 2 == 0 ? themeColor.dark : themeColor.light
    }
    var body: some View {
        GeometryReader { geometry in
            ZStack() {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(0..<64) { idx in
                        ZStack {
                            Rectangle() // The square background
                                .fill(color(for: idx))
                                .aspectRatio(1, contentMode: .fill)
                            store.game.board.squares[idx].piece?.UI.asView()
                                .onDrag({ NSItemProvider(object:  Chess.Position(idx).FEN as NSString) })
                            
                        }
                    }
                }
            }
            .frame(width: geometry.size.minimumLength,
                   height: geometry.size.minimumLength,
                   alignment: .center)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView().environmentObject(previewChessStore)
        // See ChessStore+Preview.swift for ^^ this
    }
}
