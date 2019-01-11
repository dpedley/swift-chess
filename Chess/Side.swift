//
//  Side.swift
//  LeelaChessZero
//
//  Created by Douglas Pedley on 1/6/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess {
    public enum Side: String {
        case black = "b"
        case white = "w"
        var rankDirection: Int {
            switch self {
            case .black:
                return -1
            case .white:
                return 1
            }
        }
        var FEN: String {
            return self.rawValue
        }
        var description: String {
            return self == .black ? "black" : "white"
        }
        
        var opposingSide: Side {
            return (self == .black) ? .white : .black
        }
        
        func twoSquareMove(fromString: String) -> Move? {
            guard fromString.count==4 else {
                return nil
            }
            let startPosition = String(fromString.dropLast(2))
            let endPosition = String(fromString.dropFirst(2))
            return Move(side: self, start: Position.from(rankAndFile: startPosition), end: Position.from(rankAndFile: endPosition))
        }
    }
}
