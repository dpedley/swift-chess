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
struct PieceView: View {
    @EnvironmentObject var store: ChessStore
    let position: Chess.Position
    var body: some View {
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
}

// False positives disabled.
// swiftlint:disable line_length colon
struct PieceViewPreview: PreviewProvider {
    static var store = ChessStore(game: .sampleGame())
    static var previews: some View {
        ZStack {
            PieceView(position: .d8)
                .environmentObject(store)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: -50, y: -50)
            PieceView(position: .c1)
                .environmentObject(store)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: 50, y: -50)
            PieceView(position: .e1)
                .environmentObject(store)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: -50, y: 50)
            PieceView(position: .b8)
                .environmentObject(store)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: 50, y: 50)
        }
        .frame(width: 200, height: 200, alignment: .center)
    }
}
// swiftlint:enable line_length colon
