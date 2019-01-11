//
//  SideEffect.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/10/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.Move {
    // TECH DEBT: Might be better to move the current king in attack stuff, and create a side effect of a move that is kingAttacked
    enum SideEffect {
        case notKnown
        case castling(rook: Int, destination: Int)
        case enPassant(attack: Int, trespasser: Int)
        case simulating // To force a move when we're in simulations
        case noneish // Don't make this none until we're done
    }
    
    func cloneForSimulation() -> Chess.Move {
        let aCopy = self.clone()
        aCopy.setSimulated()
        return aCopy
    }
    
    func setSimulated() {
        switch sideEffect {
        case .notKnown:
            sideEffect = .simulating
        default:
            break
        }
    }
    
    func setVerified() {
        switch sideEffect {
        case .notKnown:
            sideEffect = .noneish
        default:
            break
        }
    }
}
