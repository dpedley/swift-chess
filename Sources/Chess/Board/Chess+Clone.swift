//
//  Chess+Clone.swift
//
//  Created by Douglas Pedley on 1/10/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation
/*
extension Chess.Move.SideEffect {
    enum BaseInt: Int64 {
        case notKnown = 0, castling, enPassantInvade, enPassantCapture, promotion, none
        func annotated(with subValues: [Int]) -> Int64 {
            var updatedValue = self.rawValue
            var subValueOffset = 6
            for subValue in subValues {
                updatedValue = updatedValue | Int64(subValue << subValueOffset)
                subValueOffset += 6
            }
            return updatedValue
        }
        func annotated(with piece: Chess.Piece) -> Int64 {
            var updatedValue = self.rawValue

            // DEV NOTE: We only need to annotate the piece type, not the hasMoved,
            // this is a safe assumption in SideEffects, because a side effect happens
            // following a move.
            guard let pieceChar = piece.FEN.first,
                let subValue = pieceChar.unicodeScalars.first else {
                fatalError("A FEN should always be a character.")
            }
            updatedValue = updatedValue | Int64(subValue.value << 8)
            return updatedValue
        }
    }
    func asInt64() -> Int64 {
        switch self {
        case .notKnown:
            return BaseInt.notKnown.rawValue
        case .castling(let rook, let guardingSquare):
            return BaseInt.castling.annotated(with: [rook, guardingSquare])
        case .enPassantInvade(let territory, let invader):
            return BaseInt.enPassantInvade.annotated(with: [territory, invader])
        case .enPassantCapture(let attack, let trespasser):
            return BaseInt.enPassantCapture.annotated(with: [attack, trespasser])
        case .promotion(let piece):
            return BaseInt.promotion.annotated(with: piece)
        case .noneish:
            return BaseInt.none.rawValue
        }
    }
    static func from(Int64 value: Int64) -> Chess.Move.SideEffect? {
        let baseValue = Int(value & 63)
        guard let baseInt = BaseInt(rawValue: Int64(baseValue)) else {
            return nil
        }
        switch baseInt {
        case .notKnown:
            return .notKnown
        case .castling:
            let rook = Int(value >> 6) & 63
            let guardingSquare = Int(value >> 12) & 63
            return .castling(rook: rook, destination: guardingSquare)
        case .enPassantInvade:
            let territory = Int(value >> 6) & 63
            let invader = Int(value >> 12) & 63
            return .enPassantInvade(territory: territory, invader: invader)
        case .enPassantCapture:
            let attack = Int(value >> 6) & 63
            let trespasser = Int(value >> 12) & 63
            return .enPassantCapture(attack: attack, trespasser: trespasser)
        case .promotion:
            guard let unicodeScalar = Unicode.Scalar(Int(value >> 8)),
             let piece = Chess.Piece.from(fen: String(Character(unicodeScalar))) else {
                fatalError("Couldn't parse piece FEN")
            }
            return .promotion(piece: piece)
        case .none:
            return .noneish
        }
    }
    func clone() -> Chess.Move.SideEffect {
        return Chess.Move.SideEffect.from(Int64: self.asInt64())!
    }
}
*/
