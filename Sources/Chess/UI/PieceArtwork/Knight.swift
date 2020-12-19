//
//  Knight.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/22/20.
//

import Foundation
import SwiftUI

extension PieceArtwork {
    static let knight: PieceArtwork = {
        // We start right on top center (just right or the ear)
        let start = CGPoint.xy(0, -0.7)
        let strokes = [
            // First curve is behind the ears down the back
            Stroke.curve(to: .xy(0.75, 0.8),
                         with: .xy(0.75, -0.7),
                         and: .xy(0.8, 0.3)),
            // the base
            Stroke.to(.xy(-0.45, 0.8)),
            // Neck curve
            Stroke.curve(to: .xy(0, 0),
                         with: .xy(-0.45, 0.3),
                         and: .xy(0, 0.2)),
            // to the jaw
            Stroke.to(.xy(0, -0.15)),
            // Jaw curves
            Stroke.curve(to: .xy(-0.45, 0.3),
                         with: .xy(0, 0),
                         and: .xy(-0.3, 0.15)),
            Stroke.curve(to: .xy(-0.575, 0.2),
                         with: .xy(-0.55, 0.5),
                         and: .xy(-0.7, 0.4)),
            Stroke.curve(to: .xy(-0.85, 0.4),
                         with: .xy(-0.6, 0.25),
                         and: .xy(-0.7, 0.4)),
            // Nose curves
            Stroke.curve(to: .xy(-0.8, 0),
                         with: .xy(-0.95, 0.35),
                         and: .xy(-0.95, 0.2)),
            Stroke.curve(to: .xy(-0.5, -0.7),
                         with: .xy(-0.75, -0.2),
                         and: .xy(-0.6, -0.6)),
            // Ears
            Stroke.curve(to: .xy(-0.3, -0.725),
                         with: .xy(-0.6, -1),
                         and: .xy(-0.3, -0.95)),
            Stroke.to(.xy(-0.2, -0.7275)),
            Stroke.curve(to: .xy(0, -0.7),
                         with: .xy(-0.2, -0.95),
                         and: .xy(0.1, -1))]
        let highlights = [
            Highlight(.xy(-0.775, 0.175)),
            Highlight(.xy(-0.45, -0.45)),
            Highlight(.xy(-0.475, -0.4375)),
            Highlight(.xy(-0.475, -0.425)),
            Highlight(.xy(-0.5, -0.4)),
            Highlight(.xy(0, -0.625),
                      stroke: Stroke.curve(to: .xy(0.6775, 0.8),
                             with: .xy(0.65, -0.625),
                             and: .xy(0.7, 0.2)))]
        return PieceArtwork(start: start,
                                  strokes: strokes,
                                  jewels: [],
                                  highlights: highlights)
    }()
}

struct KnightPreview: PreviewProvider {
    static var store = ChessStore(game: .sampleGame())
    static var previews: some View {
        ZStack {
            DraggablePiece(position: .b8)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: -50, y: 0)
            DraggablePiece(position: .b1)
                .environmentObject(store)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(x: 50, y: 0)
        }
        .frame(width: 200, height: 200, alignment: .center)
    }
}
