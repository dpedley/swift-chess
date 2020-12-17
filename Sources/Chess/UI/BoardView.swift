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
                            SquareBackground(idx)
                                .pieceDrop(idx)
                            SquareMoveHighlight(idx)
                            SquareSelected(idx)
                            SquareTargeted(idx)
                            PieceView(position: idx)
                                .pieceDrag(idx)
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
        VStack {
            BoardView()
                .environmentObject(previewChessStore)
            // See ChessStore+Preview.swift for ^^ this
            HStack {
                Button {
                    previewChessStore.environmentChange(.boardColor(newColor: .brown))
                } label: {
                    BoardIconView(.brown)
                }
                Button {
                    previewChessStore.environmentChange(.boardColor(newColor: .blue))
                } label: {
                    BoardIconView(.blue)
                }
                Button {
                    previewChessStore.environmentChange(.boardColor(newColor: .green))
                } label: {
                    BoardIconView(.green)
                }
                Button {
                    previewChessStore.environmentChange(.boardColor(newColor: .purple))
                } label: {
                    BoardIconView(.purple)
                }
            }
        }
    }
}
