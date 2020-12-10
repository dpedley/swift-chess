//
//  PieceType.swift
//
//  Created by Douglas Pedley on 1/9/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

public extension Chess {
    enum PieceType {
        case pawn(hasMoved: Bool)
        case knight(hasMoved: Bool)
        case bishop(hasMoved: Bool)
        case rook(hasMoved: Bool, isKingSide: Bool)
        case queen(hasMoved: Bool)
        case king(hasMoved: Bool)
        var hasMoved: Bool {
            switch self {
            case .pawn(let hasMoved),
                 .knight(let hasMoved),
                 .bishop(let hasMoved),
                 .rook(let hasMoved, _),
                 .queen(let hasMoved),
                 .king(let hasMoved):
                return hasMoved
            }
        }
        func pieceMoved() -> PieceType {
            switch self {
            case .pawn(let hasMoved):
                return hasMoved ? .pawn(hasMoved: true) : self
            case .rook(let hasMoved, let isKingSide):
                return hasMoved ? .rook(hasMoved: true, isKingSide: isKingSide) : self
            case .king(let hasMoved):
                return hasMoved ? .king(hasMoved: true) : self
            case .knight(let hasMoved):
                return hasMoved ? .knight(hasMoved: true) : self
            case .bishop(let hasMoved):
                return hasMoved ? .bishop(hasMoved: true) : self
            case .queen(let hasMoved):
                return hasMoved ? .queen(hasMoved: true) : self
            }
        }
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
