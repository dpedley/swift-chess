//
//  EnvironmentReducer.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//

import Combine

public typealias ChessEnvironmentReducer = (ChessEnvironment, ChessEnvironment.EnvironmentChange,
                                     PassthroughSubject<ChessEnvironment, Never>) -> Void
public extension ChessStore {
    static func environmentReducer(
        environment: ChessEnvironment,
        change: ChessEnvironment.EnvironmentChange,
        passThrough: PassthroughSubject<ChessEnvironment, Never>
    ) {
        var mutableEnvironment = environment
        switch change {
        case .moveHighlight(let lastMove, let choices):
            Chess.log.info("moveHighlight preferences change: \(lastMove) \(choices)")
            mutableEnvironment.preferences.highlightLastMove = lastMove
            mutableEnvironment.preferences.highlightChoices = choices
        case .boardColor(let newColor):
            Chess.log.info("boardColor: \(newColor)...")
            mutableEnvironment.theme.color = newColor
        case .target(let newTarget):
            Chess.log.info("target environment: \(newTarget)...")
            mutableEnvironment.target = newTarget
        }
        passThrough.send(mutableEnvironment)
    }
}
