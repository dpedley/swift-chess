//
//  PieceType.swift
//
//  Created by Douglas Pedley on 1/9/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

public extension Chess {
    enum PieceType {
        case pawn
        case knight
        case bishop
        case rook
        case queen
        case king
        func fen(_ side: Side = .black) -> String {
            let upper: String
            switch self {
            case .pawn:
                upper = "P"
            case .knight:
                upper = "N"
            case .bishop:
                upper = "B"
            case .rook:
                upper = "R"
            case .queen:
                upper = "Q"
            case .king:
                upper = "K"
            }
            return side == .white ? upper : upper.lowercased()
        }
        func isKing() -> Bool {
            switch self {
            case .king:
                return true
            default:
                return false
            }
        }
        func isQueen() -> Bool {
            switch self {
            case .queen:
                return true
            default:
                return false
            }
        }
        func isRook() -> Bool {
            switch self {
            case .rook:
                return true
            default:
                return false
            }
        }
        func isBishop() -> Bool {
            switch self {
            case .bishop:
                return true
            default:
                return false
            }
        }
        func isKnight() -> Bool {
            switch self {
            case .knight:
                return true
            default:
                return false
            }
        }
        func isPawn() -> Bool {
            switch self {
            case .pawn:
                return true
            default:
                return false
            }
        }
    }
}
