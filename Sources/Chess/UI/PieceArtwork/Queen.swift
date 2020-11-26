//
//  Queen.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/22/20.
//

import Foundation
import SwiftUI

struct Queen_Preview: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .center, content: {
            PieceView(.queen, style: .black)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: -50, y: 0)
            PieceView(.queen, style: .white)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: 50, y: 0)
        })
    }
}

extension PieceArtwork {
    static let queen: PieceArtwork = {
        // We start right on top
        let start = CGPoint.xy(0, -0.75)
        let strokes = [
            // First the crown spikes on the right
            Stroke.to(.xy(0.01, -0.749)),
            Stroke.to(.xy(0.2, 0.1)),
            Stroke.to(.xy(0.45, -0.645)),
            Stroke.to(.xy(0.455, -0.64)),
            Stroke.to(.xy(0.5, 0.15)),
            Stroke.to(.xy(0.83, -0.4)),
            Stroke.to(.xy(0.85, -0.38)),
            Stroke.to(.xy(0.7, 0.25)),
            // the right side
            Stroke.curve(to:   .xy(0.7, 0.6),
                         with: .xy(0.6, 0.4),
                         and:  .xy(0.6, 0.5)),
            Stroke.curve(to:   .xy(0.7, 0.8),
                         with: .xy(0.75, 0.6),
                         and:  .xy(0.75, 0.8)),
            // The base
            Stroke.curve(to:   .xy(-0.7, 0.8),
                         with: .xy(0.65, 0.825),
                         and:  .xy(-0.65, 0.825)),
            // the left side
            Stroke.curve(to:   .xy(-0.7, 0.6),
                         with: .xy(-0.75, 0.8),
                         and:  .xy(-0.75, 0.6)),
            Stroke.curve(to:   .xy(-0.7, 0.25),
                         with: .xy(-0.6, 0.5),
                         and:  .xy(-0.6, 0.4)),
            // The crown spikes on the left
            Stroke.to(.xy(-0.85, -0.38)),
            Stroke.to(.xy(-0.83, -0.4)),
            Stroke.to(.xy(-0.5, 0.15)),
            Stroke.to(.xy(-0.445, -0.65)),
            Stroke.to(.xy(-0.45, -0.65)),
            Stroke.to(.xy(-0.2, 0.1)),
            Stroke.to(.xy(-0.01, -0.749))
        ]
        let circles = [
            Jewel(center: .xy(-0.85, -0.52), size: 0.1),
            Jewel(center: .xy(-0.4675, -0.75), size: 0.1),
            Jewel(center: .xy(0, -0.88), size: 0.1),
            Jewel(center: .xy(0.4675, -0.75), size: 0.1),
            Jewel(center: .xy(0.85, -0.52), size: 0.1)
        ]
        let highlights = [
            Highlight(.xy(0.7, 0.275),
                      stroke: .curve(to: .xy(-0.7, 0.275),
                                     with: .xy(0.5, 0.175),
                                     and: .xy(-0.5, 0.175))),
            Highlight(.xy(0.65, 0.45),
                      stroke: .curve(to: .xy(-0.65, 0.45),
                                     with: .xy(0.5, 0.35),
                                     and: .xy(-0.5, 0.35))),
            Highlight(.xy(0.7, 0.575),
                      stroke: .curve(to: .xy(-0.7, 0.575),
                                     with: .xy(0.5, 0.6),
                                     and: .xy(-0.5, 0.6))),
        ]
        return PieceArtwork(start: start,
                                  strokes: strokes,
                                  jewels: circles,
                                  highlights: highlights)
    }()
}
