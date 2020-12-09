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
    public var target: TargetEnvironment = .development
    public var theme = Chess.UI.ChessTheme()
    public init() {}
}
