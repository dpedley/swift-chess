//
//  Defaults.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

public extension Chess.UI {
    public enum Default {
        public static let devNull: Chess_GameVisualizing = Chess.UI.NilVisualizer()
        public static let debugVisualizer: Chess_GameVisualizing = Chess.UI.DebugVisualizer()
        public static let unicodeVisualizer: Chess_GameVisualizing = Chess.UI.UnicodeVisualizer()
    }
}
