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
                                .fill(color(store.environment.theme.color, for: idx))
                                .aspectRatio(1, contentMode: .fill)
                            Rectangle()
                                .fill(highlight(store.environment.preferences.highlightLastMove,
                                                lastMove: store.game.board.lastMove,
                                                for: idx))
                                .aspectRatio(1, contentMode: .fill)
                            Circle()
                                .inset(by: geometry.size.width / 3)
                                .fill(targeted(store.environment.preferences.highlightChoices,
                                               square: store.game.board.squares[idx]))
                            PieceView(position: idx)
                                .environmentObject(store)
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
    static let chessMoveHighlight = Color(.sRGB, red: 0.0, green: 0.1, blue: 0.9, opacity: 0.3)
    static let chessChoiceHighlight = Color(.sRGB, red: 1.0, green: 0.0, blue: 0.0, opacity: 0.3)
    public func highlight(_ showHighlight: Bool, lastMove: Chess.Move?, for index: Int) -> Color {
        guard showHighlight, let lastMove = lastMove else {
            return .clear
        }
        guard lastMove.start == index
                || lastMove.end == index else {
            return .clear
        }
        return BoardView.chessMoveHighlight
    }
    public func targeted(_ showChoice: Bool, square: Chess.Square) -> Color {
        guard showChoice, square.targetedBySelected else {
            return .clear
        }
        return BoardView.chessChoiceHighlight
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
