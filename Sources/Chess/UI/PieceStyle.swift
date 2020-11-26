//
//  PieceStyle.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/23/20.
//

import Foundation
import SwiftUI

class PieceStyle: ObservableObject {
    @Published var lineWidth: CGFloat
    @Published var outline: Color
    @Published var fill: Color
    @Published var highlight: Color
    init(lineWidth: CGFloat = 5, outline: Color = .black, fill: Color, highlight: Color) {
        self.outline = outline
        self.fill = fill
        self.highlight = highlight
        self.lineWidth = lineWidth
    }
    static let black = PieceStyle(fill: .black, highlight: .white)
    static let white = PieceStyle(fill: .white, highlight: .black)
}
