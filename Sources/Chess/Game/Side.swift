//
//  Side.swift
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
    }
}
