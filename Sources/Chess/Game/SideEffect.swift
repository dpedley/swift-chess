//
//  SideEffect.swift
//
//  Created by Douglas Pedley on 1/10/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

public extension Chess.Move {
    enum SideEffect: Error {
        case notKnown
        case castling(rook: Int, destination: Int)
        case enPassantInvade(territory: Int, invader: Int)
        case enPassantCapture(attack: Int, trespasser: Int)
        case promotion(piece: Chess.PieceType)
        case verified
        var isUnknown: Bool {
            switch self {
            case .notKnown, .verified:
                return true
            default:
                return false
            }
        }
    }
}
