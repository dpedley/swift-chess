//
//  PieceStyle.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/23/20.
//

import Foundation
import SwiftUI

public struct PieceStyle {
    var lineWidth: CGFloat
    var outline: Color
    var fill: Color
    var highlight: Color
    init(lineWidth: CGFloat = 5, outline: Color = .black, fill: Color, highlight: Color) {
        self.outline = outline
        self.fill = fill
        self.highlight = highlight
        self.lineWidth = lineWidth
    }
    static let black = PieceStyle(fill: .black, highlight: .white)
    static let white = PieceStyle(fill: .white, highlight: .black)
}
