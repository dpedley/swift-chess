//
//  Robot+Choices.swift
//  
//
//  Created by Douglas Pedley on 12/10/20.
//

import Foundation

public protocol RoboticMoveDecider {
    func validChoices(board: Chess.Board) -> [Chess.SingleMoveVariant]?
    func evalutate(board: Chess.Board) -> Chess.Move?
}
