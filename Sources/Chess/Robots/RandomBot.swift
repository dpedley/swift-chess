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
        func worthyChoices(board: Chess.Board) -> [Chess.Move]? {
            return board.createValidVariants(for: side)?.compactMap( { $0.move })
        }
        
        override func evalutate(board: Chess.Board) -> Chess.Move? {
            // When in doubt, pick a random move
            return worthyChoices(board: board)?.randomElement()
        }
    }
}

