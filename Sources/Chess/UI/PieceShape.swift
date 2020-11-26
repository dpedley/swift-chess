//
//  PieceShape.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/21/20.
//

import Foundation
import SwiftUI

struct PieceShape: Shape {
    var inset: CGFloat = 20
    let artwork: PieceArtwork
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: artwork.start.mapped(in: rect, inset: inset) )
            for shapePoint in artwork.strokes {
                guard let control1 = shapePoint.control1 else {
                    // It's just a line
                    path.addLine(to: shapePoint.end.mapped(in: rect, inset: inset))
                    continue
                }
                guard let control2 = shapePoint.control2 else {
                    // It's a single control curve
                    path.addQuadCurve(to: shapePoint.end.mapped(in: rect, inset: inset),
                                      control: control1.mapped(in: rect, inset: inset))
                    continue
                }
                path.addCurve(to: shapePoint.end.mapped(in: rect, inset: inset),
                                  control1: control1.mapped(in: rect, inset: inset),
                                  control2: control2.mapped(in: rect, inset: inset))
            }
            path.closeSubpath()
            let start = Angle(degrees: 90)
            let end = Angle(degrees: 450)
            for circle in artwork.jewels {
                let circleCenter = circle.center.mapped(in: rect, inset: inset)
                let circleRadius = circle.size * rect.width / 2
                path.move(to: circleCenter.applying(.init(translationX: 0, y: circleRadius)))
                path.addArc(center: circleCenter,
                            radius: circleRadius,
                            startAngle: start,
                            endAngle: end,
                            clockwise: false)
            }
        }
    }
}
