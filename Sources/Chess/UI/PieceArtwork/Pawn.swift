//
//  BlackPawn.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/15/20.
//

import Foundation
import SwiftUI

extension PieceArtwork {
    static let pawn = PieceArtwork(start: .xy(0, -0.65),
                                    strokes: [
        // right side
        Stroke.curve(to: .xy(0.15, -0.3),
                     with: .xy(0.3, -0.6)),
        Stroke.curve(to: .xy(0.2, 0.2),
                     with: .xy(0.45, -0.05)),
        Stroke.curve(to: .xy(0.6, 0.9),
                     with: .xy(0.6, 0.45)),
        // the base
        Stroke.to(.xy(-0.6, 0.9)),
        // the left
        Stroke.curve(to: .xy(-0.2, 0.2),
                     with: .xy(-0.6, 0.45)),
        Stroke.curve(to: .xy(-0.15, -0.3),
                     with: .xy(-0.45, -0.05)),
        Stroke.curve(to: .xy(0, -0.65),
                     with: .xy(-0.3, -0.6))
    ])
}

struct PawnPreview: PreviewProvider {
    static var store = ChessStore(game: .sampleGame())
    static var previews: some View {
        ZStack {
            DraggablePiece(position: .a7)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: -50, y: 0)
            DraggablePiece(position: .a2)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 50, y: 0)
        }
        .frame(width: 200, height: 200, alignment: .center)
    }
}
