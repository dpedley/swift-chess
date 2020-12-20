//
//  Bishop.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/15/20.
//

import Foundation
import SwiftUI

extension PieceArtwork {
    static let bishop: PieceArtwork = {
        // We start right on top
        let start = CGPoint.xy(0, -0.6)
        let strokes = [
            // First curve is the right side around the cross
            Stroke.curve(to: .xy(0.25, 0.1),
                         with: .xy(0.45, -0.45),
                         and: .xy(0.45, 0.1)),
            // the right side around lower body
            Stroke.curve(to: .xy(0, 0.6),
                         with: .xy(0.4, 0.35),
                         and: .xy(0.4, 0.6)),
            // the right side top line of the base
            Stroke.curve(to: .xy(0.75, 0.725),
                         with: .xy(0.2, 0.75),
                         and: .xy(0.7, 0.6)),
            // the right toe
            Stroke.to(.xy(0.8, 0.75)),
            Stroke.to(.xy(0.75, 0.8)),
            Stroke.to(.xy(0.65, 0.8)),
            // the right side bottom line of the base
            Stroke.curve(to: .xy(0, 0.75),
                         with: .xy(0.325, 0.725),
                         and: .xy(0.325, 0.8)),
            // the left side bottom line of the base
            Stroke.curve(to: .xy(-0.65, 0.8),
                         with: .xy(-0.325, 0.8),
                         and: .xy(-0.325, 0.725)),
            // the left toe
            Stroke.to(.xy(-0.75, 0.8)),
            Stroke.to(.xy(-0.8, 0.75)),
            Stroke.to(.xy(-0.75, 0.725)),
            // the left side top line of the base
            Stroke.curve(to: .xy(0, 0.6),
                         with: .xy(-0.7, 0.6),
                         and: .xy(-0.2, 0.75)),
            // the left side around lower body
            Stroke.curve(to: .xy(-0.25, 0.1),
                         with: .xy(-0.4, 0.6),
                         and: .xy(-0.4, 0.35)),
            // continue up the left side around the cross
            Stroke.curve(to: .xy(0, -0.6),
                         with: .xy(-0.45, 0.1),
                         and: .xy(-0.45, -0.45))
        ]
        let jewels = [Jewel(center: .xy(0, -0.75), size: 0.125)]
        let highlights = [
            Highlight(.xy(0, -0.4), stroke: .to(.xy(0, -0.1))),
            Highlight(.xy(0.15, -0.25), stroke: .to(.xy(-0.15, -0.25))),
            Highlight(.xy(0.265, 0.11), stroke: .to(.xy(-0.265, 0.11))),
            Highlight(.xy(0.375, 0.4), stroke: .to(.xy(-0.375, 0.4)))
        ]
        return PieceArtwork(start: start,
                                  strokes: strokes,
                                  jewels: jewels,
                                  highlights: highlights)
    }()
}

struct BishopPreview: PreviewProvider {
    static var store = ChessStore(game: .sampleGame())
    static var previews: some View {
        ZStack {
            DraggablePiece(position: .c8)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: -50, y: 0)
            DraggablePiece(position: .c1)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 50, y: 0)
        }
        .frame(width: 200, height: 200, alignment: .center)
    }
}
