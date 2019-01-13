//
//  Visualize.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

public protocol Chess_UISquareVisualizer {
    mutating func setSelected(_ selectionType: Chess.UI.Selection)
    mutating func setOccupant(_ piece: Chess.UI.Piece)
}

public protocol Chess_UIGameVisualizer {
    var squares: [Chess_UISquareVisualizer] { get set }
    func blackCaptured(_ piece: Chess.UI.Piece)
    func whiteCaptured(_ piece: Chess.UI.Piece)
}

extension Chess.UI {
    class NilVisualizer: Chess_GameVisualizing {
        func apply(game: Chess.Game, status: Chess.UI.Status) {}
        func apply(board: Chess_PieceCoordinating, updates: [Chess.UI.Update]) {}
    }

    class Visualizer<GameVisualizer: Chess_UIGameVisualizer>: Chess_GameVisualizing {
        var ui: GameVisualizer
        init(_ gameVisualizer: GameVisualizer) {
            self.ui = gameVisualizer
        }
        
        func applyPieceUpdate(board: Chess_PieceCoordinating, update: Chess.UI.PieceUpdate) {
            switch update {
            case .capture(let piece, let start, let capturedPiece, let end): // _ capturedPiece
                self.ui.squares[start].setOccupant(.none)
                self.ui.squares[end].setOccupant(piece)
                switch piece {
                case .blackPawn, .blackKnight, .blackBishop, .blackRook, .blackQueen, .blackKing:
                    self.ui.blackCaptured(capturedPiece)
                case .whitePawn, .whiteKnight, .whiteBishop, .whiteRook, .whiteQueen, .whiteKing:
                    self.ui.whiteCaptured(capturedPiece)
                case .none:
                    break
                }
            case .moved(let piece, let start, let end):
                self.ui.squares[start].setOccupant(.none)
                self.ui.squares[end].setOccupant(piece)
            }
        }

        func applySelectionUpdate(board: Chess_PieceCoordinating, update: Chess.UI.SelectionUpdate, positions: [Chess.Position]) {
            let selectionType: Chess.UI.Selection
            switch update {
            case .isAttackableBySelectedPeice:
                selectionType = .target
            case .isSelected:
                selectionType = .selected
            case .selectionsCleared:
                selectionType = .none
            }
            
            positions.forEach {
                self.ui.squares[$0].setSelected(selectionType)
            }
        }
        
        func apply(game: Chess.Game, status: Chess.UI.Status) {
            
        }
        
        func apply(board: Chess_PieceCoordinating, updates: [Chess.UI.Update]) {
            guard self.ui.squares.count == 64 else { return } // Make sure we've been initialized
            for update in updates {
                switch update {
                case .clearSquare(let position):
                    self.ui.squares[position].setOccupant(.none)
                case .piece(let pieceUpdate):
                    self.applyPieceUpdate(board: board, update: pieceUpdate)
                case .selection(let selectionUpdate, let positions):
                    self.applySelectionUpdate(board: board, update: selectionUpdate, positions: positions)
                case .resetBoard(let pieces):
                    guard pieces.count == 64 else { return }
                    for index in 0...63 {
                        self.ui.squares[index].setOccupant(pieces[index])
                    }
                }
            }
        }
    }
}
