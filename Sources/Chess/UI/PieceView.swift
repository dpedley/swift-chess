//
//  ChessPiece.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/19/20.
//

import Foundation
import SwiftUI

public struct DraggablePiece: View {
    @EnvironmentObject var store: ChessStore
    let position: Chess.Position
    public var body: some View {
        guard let piece = store.game.board.squares[position].piece else {
            return AnyView(EmptyView())
        }
        return AnyView(PieceView(piece: piece)
            .onDrag {
                store.gameAction(.userDragged(position: position))
                return NSItemProvider(object: self.position.FEN as NSString)
            }
        )
    }
    public init(position: Chess.Position) {
        self.position = position
    }
}

/// PieceView
///
/// This is the view used for the chess pieces.
/// The artwork controls which piece you see
/// The style has the colors.
public struct PieceView: View {
    let piece: Chess.Piece
    let addDetails: Bool
    func details(piece: Chess.Piece) -> some View {
        guard addDetails else {
            return AnyView(EmptyView())
        }
        return AnyView(
            // Render the details in the highlight color
            PieceShape.Details(artwork: piece.artwork)
                .stroke(piece.style.highlight, lineWidth: 1.5)
        )
    }
    public var body: some View {
        ZStack {
            // Paint the piece
            PieceShape(artwork: piece.artwork)
                .foregroundColor(piece.style.fill)
            // Then outline it
            PieceShape(artwork: piece.artwork)
                .stroke(piece.style.outline)
            details(piece: piece)
        }
    }
    public init(piece: Chess.Piece,
                addDetails: Bool = true) {
        self.piece = piece
        self.addDetails = addDetails
    }
}

// False positives disabled.
struct PieceViewPreview: PreviewProvider {
    static var store = ChessStore(game: .sampleGame())
    static var previews: some View {
        ZStack {
            DraggablePiece(position: .d8)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: -50, y: -50)
            DraggablePiece(position: .c1)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 50, y: -50)
            DraggablePiece(position: .e1)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: -50, y: 50)
            DraggablePiece(position: .b8)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 50, y: 50)
        }
        .frame(width: 200, height: 200, alignment: .center)
    }
}
