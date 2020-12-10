//
//  RandomBot.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI

public extension Chess.Robot {
    class RandomBot: Chess.Robot {
        public func worthyChoices(board: Chess.Board) -> [Chess.Move]? {
            return board.createValidVariants(for: side)?.compactMap { $0.move }
        }
        public override func evalutate(board: Chess.Board) -> Chess.Move? {
            guard board.playingSide == side else { return nil }
            // When in doubt, pick a random move
            guard let worthyChoices = worthyChoices(board: board) else {
                print("No moves chosen.")
                return nil
            }
            return worthyChoices.randomElement()
        }
    }
}
