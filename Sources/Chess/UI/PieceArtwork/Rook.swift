//
//  Rook.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/21/20.
//
import Foundation
import SwiftUI

extension PieceArtwork {
    static let rook: PieceArtwork = {
        // We start center top
        let start = CGPoint.xy(0, -0.7)
        let strokes = [
            // right parapet
            Stroke.to(.xy(0.15, -0.7)),
            Stroke.to(.xy(0.15, -0.575)),
            Stroke.to(.xy(0.35, -0.575)),
            Stroke.to(.xy(0.35, -0.7)),
            Stroke.to(.xy(0.55, -0.7)),

            // right side
            Stroke.to(.xy(0.55, -0.4)),
            Stroke.to(.xy(0.4, -0.3)),
            Stroke.to(.xy(0.4, 0.35)),
            Stroke.to(.xy(0.5, 0.5)),
            Stroke.to(.xy(0.5, 0.65)),

            // base
            Stroke.to(.xy(0.7, 0.65)),
            Stroke.to(.xy(0.7, 0.85)),
            Stroke.to(.xy(-0.7, 0.85)),
            Stroke.to(.xy(-0.7, 0.65)),

            // left side
            Stroke.to(.xy(-0.5, 0.65)),
            Stroke.to(.xy(-0.5, 0.5)),
            Stroke.to(.xy(-0.4, 0.35)),
            Stroke.to(.xy(-0.4, -0.3)),
            Stroke.to(.xy(-0.55, -0.4)),

            // left parapet
            Stroke.to(.xy(-0.55, -0.7)),
            Stroke.to(.xy(-0.35, -0.7)),
            Stroke.to(.xy(-0.35, -0.575)),
            Stroke.to(.xy(-0.15, -0.575)),
            Stroke.to(.xy(-0.15, -0.7)),
            Stroke.to(.xy(0, -0.7))
        ]
        let highlights = [
            Highlight(.xy(0.55, -0.4), stroke: .to(.xy(-0.55, -0.4))),
            Highlight(.xy(0.5, 0.5), stroke: .to(.xy(-0.5, 0.5))),
            Highlight(.xy(0.5, 0.625), stroke: .to(.xy(-0.5, 0.625))),
            Highlight(.xy(0.4, -0.3), stroke: .to(.xy(-0.4, -0.3))),
            Highlight(.xy(0.4, 0.35), stroke: .to(.xy(-0.4, 0.35)))
        ]
        return PieceArtwork(start: start,
                                  strokes: strokes,
                                  jewels: [],
                                  highlights: highlights)
    }()
}

struct RookPreview: PreviewProvider {
    static var store = ChessStore(game: .sampleGame())
    static var previews: some View {
        ZStack {
            DraggablePiece(position: .a8)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: -50, y: 0)
            DraggablePiece(position: .a1)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 50, y: 0)
        }
        .frame(width: 200, height: 200, alignment: .center)

    }
}
