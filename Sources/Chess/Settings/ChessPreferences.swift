//
//  File.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//

import SwiftUI

public extension Chess.UI {
    struct Preferences {
        @AppStorage("highlightLastMove", store: ChessEnvironment.defaults)
            var highlightLastMove: Bool = true
        @AppStorage("highlightChoices", store: ChessEnvironment.defaults)
            var highlightChoices: Bool = true
    }
}
