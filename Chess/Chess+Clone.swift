//
//  Chess+Clone.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/10/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.Move.SideEffect {
    enum BaseInt: Int64 {
        case notKnown = 0, castling, enPassant, simulating, none
        func annotated(with subValues: [Int]) -> Int64 {
            var updatedValue = self.rawValue
            var subValueOffset = 6
            for subValue in subValues {
                updatedValue = updatedValue | Int64(subValue << subValueOffset)
                subValueOffset += 6
            }
            return updatedValue
        }
    }
    
    func asInt64() -> Int64 {
        switch self {
        case .notKnown:
            return BaseInt.notKnown.rawValue
        case .castling(let rook, let guardingSquare):
            return BaseInt.castling.annotated(with: [rook, guardingSquare])
        case .enPassant(let attack, let trespasser):
            return BaseInt.enPassant.annotated(with: [attack, trespasser])
        case .simulating:
            return BaseInt.simulating.rawValue
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
        case .enPassant:
            let attack = Int(value >> 6) & 63
            let trespasser = Int(value >> 12) & 63
            return .enPassant(attack: attack, trespasser: trespasser)
        case .simulating:
            return .simulating
        case .none:
            return .noneish
        }
    }
    
    func clone() -> Chess.Move.SideEffect {
        return Chess.Move.SideEffect.from(Int64: self.asInt64())!
    }
}

extension Chess.Side {
    func clone() -> Chess.Side {
        return (self == .black) ? .black : .white
    }
}

extension Chess.Move {
    func clone() -> Chess.Move {
        let cloned = Chess.Move(side: side.clone(), start: start, end: end)
        cloned.sideEffect = sideEffect.clone()
        return cloned
    }
}
