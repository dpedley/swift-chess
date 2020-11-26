//
//  Artwork+Drawing.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/23/20.
//

import Foundation
import SwiftUI

extension PieceArtwork {
    struct Stroke {
        let end: CGPoint
        let control1: CGPoint?
        let control2: CGPoint?
        static func to(_ point: CGPoint) -> Stroke {
            return Stroke(end: point, control1: nil, control2: nil)
        }
        static func curve(to point: CGPoint, with control1: CGPoint, and control2: CGPoint? = nil) -> Stroke {
            return Stroke(end: point, control1: control1, control2: control2)
        }
    }

    struct Jewel {
        let center: CGPoint
        let size: CGFloat
    }

    struct Highlight {
        let point: CGPoint
        let stroke: Stroke?
        let isLight: Bool
        init(_ point: CGPoint, stroke: Stroke? = nil, isLight: Bool = false) {
            self.point = point
            self.stroke = stroke
            self.isLight = isLight
        }
    }
}
