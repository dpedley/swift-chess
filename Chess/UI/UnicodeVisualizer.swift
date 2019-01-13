//
//  UnicodeVisualizer.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.UI {
    class UnicodeVisualizer: DebugVisualizer {
        override func string(describing piece: Chess.Piece?) -> String {
            return piece?.unicode ?? " "
        }
    }
}
