//
//  King.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/22/20.
//

import Foundation
import SwiftUI

extension PieceArtwork {
    static let king: PieceArtwork = {
        // We start right on top
        let start = CGPoint.xy(0, -0.6)
        let strokes = [
            // the right side
            Stroke.curve(to: .xy(0.15, -0.3),
                         with: .xy(0.15, -0.6),
                         and: .xy(0.2, -0.32)),
            Stroke.curve(to: .xy(0.55, 0.3),
                         with: .xy(0.8, -0.65),
                         and: .xy(1, 0)),
            Stroke.to(.xy(0.55, 0.65)),
            // the base
            Stroke.curve(to: .xy(-0.55, 0.65),
                         with: .xy(0.2, 0.9),
                         and: .xy(-0.2, 0.9)),
            // the left
            Stroke.to(.xy(-0.55, 0.3)),
            Stroke.curve(to: .xy(-0.15, -0.3),
                         with: .xy(-1, 0),
                         and: .xy(-0.8, -0.65)),
            Stroke.curve(to: .xy(0, -0.6),
                         with: .xy(-0.2, -0.32),
                         and: .xy(-0.15, -0.6)),
            // the cross
            Stroke.to(.xy(0, -0.9)),
            Stroke.to(.xy(0, -0.75)),
            Stroke.to(.xy(-0.15, -0.75)),
            Stroke.to(.xy(0.15, -0.75)),
            Stroke.to(.xy(0, -0.75)),
            Stroke.to(.xy(0, -0.6))
        ]
        let highlights = [
            Highlight(.xy(-0.55, 0.25),
                      stroke: .curve(to: .xy(0, -0.1),
                                     with: .xy(-1, 0),
                                     and: .xy(-0.625, -0.775))),
            Highlight(.xy(0.55, 0.25),
                      stroke: .curve(to: .xy(0, -0.1),
                                     with: .xy(1, 0),
                                     and: .xy(0.625, -0.775))),
            Highlight(.xy(0, 0.25),
                      stroke: .to(.xy(0, -0.1))),
            // three bands
            Highlight(.xy(0.55, 0.3),
                      stroke: .curve(to: .xy(-0.55, 0.3),
                                     with: .xy(0.5, 0.2),
                                     and: .xy(-0.5, 0.2))),
            Highlight(.xy(0.55, 0.45),
                      stroke: .curve(to: .xy(-0.55, 0.45),
                                     with: .xy(0.5, 0.35),
                                     and: .xy(-0.5, 0.35))),
            Highlight(.xy(0.55, 0.6),
                      stroke: .curve(to: .xy(-0.55, 0.6),
                                     with: .xy(0.5, 0.5),
                                     and: .xy(-0.5, 0.5)))
        ]
        return PieceArtwork(start: start,
                                  strokes: strokes,
                                  jewels: [],
                                  highlights: highlights)
    }()
}

struct KingPreview: PreviewProvider {
    static var store = ChessStore(game: .sampleGame())
    static var previews: some View {
        ZStack {
            PieceView(position: .e8)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: -50, y: 0)
            PieceView(position: .e1)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 50, y: 0)
        }
        .frame(width: 200, height: 200, alignment: .center)

    }
}
