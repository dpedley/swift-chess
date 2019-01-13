//
//  DebugVisualizer.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.UI {
    
    class DebugVisualizer: NSObject,  Chess_GameVisualizing {
        func string(describing piece: Chess.Piece?) -> String {
            return piece?.FEN ?? " "
        }

        func dumpBoard(_ board: Chess_PieceCoordinating) {
            var outputString = "\n"
            for square in board.squares {
                outputString.append(string(describing: square.piece))
                if square.position.file == "h" {
                    outputString.append("\n")
                }
            }
            print(outputString)
        }
        
        func apply(game: Chess.Game, status: Chess.UI.Status) {
            // TODO:
        }
        
        func apply(board: Chess_PieceCoordinating, updates: [Chess.UI.Update]) {
            dumpBoard(board)
        }
    }
}
