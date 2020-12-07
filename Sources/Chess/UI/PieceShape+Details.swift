//
//  PieceShape+Details.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/23/20.
//

import Foundation
import SwiftUI

extension PieceShape {
    struct Details: Shape {
        var inset: CGFloat = 0.1
        let artwork: PieceArtwork
        func path(in rect: CGRect) -> Path {
            return Path { path in
                for highlight in artwork.highlights {
                    let point = highlight.point.mapped(in: rect, inset: inset * rect.width)
                    guard let stroke = highlight.stroke else {
                        // we only have a point, draw a dot there.
                        let aLittleBit = rect.width * 0.0175
                        path.move(to: point.applying(.init(translationX: -aLittleBit, y: -aLittleBit)))
                        path.addLine(to: point.applying(.init(translationX: aLittleBit, y: aLittleBit)))
                        path.move(to: point.applying(.init(translationX: -aLittleBit, y: aLittleBit)))
                        path.addLine(to: point.applying(.init(translationX: aLittleBit, y: -aLittleBit)))
                        continue
                    }
                    path.move(to: point)
                    guard let control1 = stroke.control1 else {
                        // It's just a line
                        path.addLine(to: stroke.end.mapped(in: rect, inset: inset * rect.width))
                        continue
                    }
                    guard let control2 = stroke.control2 else {
                        // It's a single control curve
                        path.addQuadCurve(to: stroke.end.mapped(in: rect, inset: inset * rect.width),
                                          control: control1.mapped(in: rect, inset: inset * rect.width))
                        continue
                    }
                    path.addCurve(to: stroke.end.mapped(in: rect, inset: inset * rect.width),
                                      control1: control1.mapped(in: rect, inset: inset * rect.width),
                                      control2: control2.mapped(in: rect, inset: inset * rect.width))
                }
            }
        }
        init(artwork: PieceArtwork) {
            self.artwork = artwork
        }
    }
}

