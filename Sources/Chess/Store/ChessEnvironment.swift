//
//  ChessEnvironment.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import Combine

struct ChessEnvironment {
    enum TargetEnvironment {
        case production
        case development
    }
    var target: TargetEnvironment = .development
    var theme = Chess.UI.ChessTheme()
}
