//
//  ChessEnvironment.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import Combine

public struct ChessEnvironment {
    public enum TargetEnvironment {
        case production
        case development
    }
    public enum EnvironmentChange {
        case target(newTarget: TargetEnvironment)
        case boardColor(newColor: Chess.UI.BoardColor)
        case moveHighlight(lastMove: Bool, choices: Bool)
    }
    public var target: TargetEnvironment = .development
    public var theme = Chess.UI.ChessTheme()
    public var preferences = Chess.UI.Preferences()
    public init() {}
}
