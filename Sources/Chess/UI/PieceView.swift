//
//  ChessPiece.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/19/20.
//

import Foundation
import SwiftUI

/// PieceView
///
/// This is the view used for the chess pieces.
/// The artwork controls which piece you see
/// The style has the colors.
public struct PieceView: View {
    @EnvironmentObject var store: ChessStore
    let position: Chess.Position
    public var body: some View {
        ZStack {
            // Paint the piece
            PieceShape(artwork: store.game.board.squares[position].piece?.artwork)
            .foregroundColor(store.game.board.squares[position].piece?.style.fill)
            // Then outline it
            PieceShape(artwork: store.game.board.squares[position].piece?.artwork)?
            .stroke(store.game.board.squares[position].piece?.style.outline ?? .clear)
            // Render the details in the highlight color
            PieceShape.Details(artwork: store.game.board.squares[position].piece?.artwork)?
                .stroke(store.game.board.squares[position].piece?.style.highlight ?? .clear, lineWidth: 1.5)
        }
        .drawingGroup()
    }
}

// False positives disabled.
struct PieceViewPreview: PreviewProvider {
    static var store = ChessStore(game: .sampleGame())
    static var previews: some View {
        ZStack {
            PieceView(position: .d8)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: -50, y: -50)
            PieceView(position: .c1)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 50, y: -50)
            PieceView(position: .e1)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: -50, y: 50)
            PieceView(position: .b8)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 50, y: 50)
        }
        .frame(width: 200, height: 200, alignment: .center)
    }
}
