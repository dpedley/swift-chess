//
//  RandomBot.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI

extension Chess.Robot {
    class RandomBot: Chess.Robot {
        override func evalutate(board: Chess.Board) -> Chess.Move? {
            // When in doubt, pick a random move
            return board.createValidVariants(for: side)?.randomElement()?.move
        }
    }
}

