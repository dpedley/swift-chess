//
//  Visualize.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

// TODO REMOVE: There are audio / gameplay cues that should be moved first.
/*
public protocol Chess_UISquareActionHandling: class {
     // The user tapped this square
    func tap(square: Chess_UISquareVisualizer)
    
     // User began dragging in this square, if there was a piece there is it returned
    func drag(square: Chess_UISquareVisualizer) -> Chess.UI.Piece?
    
     // Dragging continued into a new square, if this square's selection should change, the new selection is returned
    func drag(entered: Chess_UISquareVisualizer) -> Chess.UI.Selection?
}

// This is the protocol that each UI square should respond to.
public protocol Chess_UISquareVisualizer {
    var position: Chess.Position? { get }
    mutating func setSelected(_ selectionType: Chess.UI.Selection)
    mutating func setOccupant(_ piece: Chess.UI.Piece)
    mutating func clear(if outdatedSelectionType: Chess.UI.Selection)
}

// This is how an app exposes it's UI elements to the Chess framework.
public protocol Chess_UIGameVisualizer {
    var squares: [Chess_UISquareVisualizer] { get set }
    func blackCaptured(_ piece: Chess.UI.Piece)
    func whiteCaptured(_ piece: Chess.UI.Piece)
    func addMoveToLedger(_ move: Chess.Move)
    func sideChanged(_ playingSide: Chess.Side)
    func clearAllSelections()
}

extension Chess.UI {
    class NilVisualizer: Chess_GameVisualizing {
        func apply(board: Chess_PieceCoordinating, status: Chess.UI.Status) {}
        func apply(board: Chess_PieceCoordinating, updates: [Chess.UI.Update]) {}
    }

    class Visualizer<GameVisualizer: Chess_UIGameVisualizer>: Chess_GameVisualizing {
        var ui: GameVisualizer
        init(_ gameVisualizer: GameVisualizer) {
            ui = gameVisualizer
        }
        
        func apply(pieceUpdate update: Chess.UI.PieceUpdate, to board: Chess_PieceCoordinating) {
            switch update {
            case .capture(let piece, let start, let capturedPiece, let end): // _ capturedPiece
                ui.squares[start].setOccupant(.none)
                ui.squares[end].setOccupant(piece)
                Chess.Sounds.Capture.play()
                
                // Send the piece to the dungeon
                switch piece {
                case .blackPawn, .blackKnight, .blackBishop, .blackRook, .blackQueen, .blackKing:
                    ui.blackCaptured(capturedPiece)
                case .whitePawn, .whiteKnight, .whiteBishop, .whiteRook, .whiteQueen, .whiteKing:
                    ui.whiteCaptured(capturedPiece)
                case .none:
                    break
                }
            case .moved(let piece, let start, let end):
                ui.squares[start].setOccupant(.none)
                ui.squares[end].setOccupant(piece)
                Chess.Sounds.Move.play()
            }
        }

        func apply(selectionUpdate: Chess.UI.Selection, to board: Chess_PieceCoordinating, at positions: [Chess.Position]) {
            positions.forEach {
                ui.squares[$0].setSelected(selectionUpdate)
            }
        }
        
        func apply(board: Chess_PieceCoordinating, status: Chess.UI.Status) {
            ui.sideChanged(status.nextToPlay)
            if status.isInCheck {
                Chess.Sounds.Check.play()
            }
        }

        func apply(deselectionType: Chess.UI.Selection) {
            for index in 0...63 {
                ui.squares[index].clear(if: deselectionType)
            }
        }

        func apply(board: Chess_PieceCoordinating, updates: [Chess.UI.Update]) {
            guard ui.squares.count == 64 else { return } // Make sure we've been initialized
            for update in updates {
                switch update {
                case .clearSquare(let position):
                    ui.squares[position].setOccupant(.none)
                case .flashSquare(let position):
                    apply(selectionUpdate: .attention, to: board, at: [position])
                    apply(selectionUpdate: .none, to: board, at: [position])
                case .piece(let pieceUpdate):
                    apply(pieceUpdate: pieceUpdate, to: board)
                case .highlight(let positions):
                    apply(selectionUpdate: .highlight, to: board, at: positions)
                case .deselect(let selectionType):
                    apply(deselectionType: selectionType)
                case .resetBoard(let pieces):
                    guard pieces.count == 64 else { return }
                    for index in 0...63 {
                        ui.squares[index].setOccupant(pieces[index])
                    }
                case .ledger(let move):
                    ui.addMoveToLedger(move)
                }
            }
        }
    }
}
*/
