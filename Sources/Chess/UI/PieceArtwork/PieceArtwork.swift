//
//  PieceArtwork.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/22/20.
//

import Foundation
import SwiftUI

public struct PieceArtwork {
    let start: CGPoint
    let strokes: [Stroke]
    let jewels: [Jewel]
    let highlights: [Highlight]
    init(start: CGPoint, strokes: [Stroke], jewels: [Jewel] = [], highlights: [Highlight] = []) {
        self.start = start
        self.strokes = strokes
        self.jewels = jewels
        self.highlights = highlights
    }
}
