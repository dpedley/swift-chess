//
//  CoreGraphics+RelativeShape.swift
//  ChessPieces
//
//  Created by Douglas Pedley on 11/23/20.
//

import Foundation
import SwiftUI

extension CGPoint {
    static let upperLeft  = CGPoint(x: -1, y: -1)
    static let upperRight = CGPoint(x: 1, y: -1)
    static let lowerLeft  = CGPoint(x: -1, y: 1)
    static let lowerRight = CGPoint(x: 1, y: 1)
    func mapped(in rect: CGRect, inset: CGFloat) -> CGPoint {
        guard x <= 1 && -1 <= x && y <= 1 && -1 <= y else {
            fatalError("Misconfigured relative point")
        }
        let dx = x * (rect.width - (2 * inset)) / 2
        let dy = y * (rect.height - (2 * inset)) / 2
        return CGPoint(x: dx + rect.midX,
                       y: dy + rect.midY)
    }
    static func xy(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return .init(x: x, y: y)
    }
}

