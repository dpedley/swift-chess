//
//  BlackPawn.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/15/20.
//

import Foundation
import SwiftUI

struct Pawn_Preview: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .center, content: {
            PieceView(.pawn, style: .black)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: -50, y: 0)
            PieceView(.pawn, style: .white)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .offset(x: 50, y: 0)
        })
    }
}

extension PieceArtwork {
    static let pawn = PieceArtwork(start: .xy(0, -0.65),
                                    strokes: [
        // right side
        Stroke.curve(to:   .xy(0.15, -0.3),
                     with: .xy(0.3, -0.6)),
        Stroke.curve(to:   .xy(0.2, 0.2),
                     with: .xy(0.45, -0.05)),
        Stroke.curve(to:   .xy(0.6, 0.9),
                     with: .xy(0.6, 0.45)),
        // the base
        Stroke.to(.xy(-0.6, 0.9)),
        // the left
        Stroke.curve(to:   .xy(-0.2, 0.2),
                     with: .xy(-0.6, 0.45)),
        Stroke.curve(to:   .xy(-0.15, -0.3),
                     with: .xy(-0.45, -0.05)),
        Stroke.curve(to:   .xy(0, -0.65),
                     with: .xy(-0.3, -0.6))
    ])
}

