//
//  Board+FEN.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/11/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.Board {
    static let startingFEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    private static let CharZero = Unicode.Scalar("0").value
    internal func createCurrentFENString() -> String {
        var fen = ""
        var emptyCount = 0
        for square in squares {
            if let piece = square.piece {
                if emptyCount>0 {
                    fen += "\(emptyCount)"
                    emptyCount = 0
                }
                fen += piece.FEN
            } else {
                emptyCount+=1
            }
            // Check if we're in the last file for this rank
            if square.position.file=="h" {
                if emptyCount>0 {
                    fen += "\(emptyCount)"
                    emptyCount = 0
                }
                
                // No slash after the final rank
                if square.position.rank>1 {
                    fen += "/"
                }
            }
        }
        var castling = ""
        if !Chess.Board.White.King.hasMoved(on: self) {
            if !Chess.Board.White.KingsSide.Rook.hasMoved(on: self) { castling += "K" }
            if !Chess.Board.White.QueensSide.Rook.hasMoved(on: self) { castling += "Q" }
        }
        if !Chess.Board.Black.King.hasMoved(on: self) {
            if !Chess.Board.Black.KingsSide.Rook.hasMoved(on: self) { castling += "k" }
            if !Chess.Board.Black.QueensSide.Rook.hasMoved(on: self) { castling += "q" }
        }
        if castling.count == 0 { castling = "-" }
        fen += " \(playingSide.FEN) \(castling) \(enPassantPosition?.FEN ?? "-") 0 \(fullMoves)"
        return fen
    }

    func resetBoard(FEN: String = Chess.Board.startingFEN) {
        turns.removeAll()
        let FENParts = FEN.components(separatedBy: " ")
        guard FENParts.count==6, let newSide = Chess.Side(rawValue: FENParts[1]) else {
            fatalError("Invalid FEN: Cannot find active side.")
        }
        playingSide = newSide
        guard let moveCount = Int(FENParts[5]) else {
            fatalError("Invalid FEN: Cannot parse fullmoves \(FENParts[5]).")
        }
        fullMoves = moveCount
        
        // TODO: castling checks in the hasMoved below
        // TODO: en passant square last move side effect additions
        
        guard let piecesString = FENParts.first else {
            fatalError("Invalid FEN")
        }
        let ranks = piecesString.components(separatedBy: "/")
        guard ranks.count==8 else {
            fatalError("Invalid FEN")
        }
        var rankIndex = 0
        for rankString in ranks {
            var fileIndex = 0
            for fenChar in rankString {
                guard let unicodeScalar = fenChar.unicodeScalars.first else {
                    // unicodeScalar error?
                    fatalError("FEN Character \(fenChar) invalid")
                }
                
                // If it's a digit, it represents the number of empty squares
                if CharacterSet.decimalDigits.contains(unicodeScalar) {
                    var emptySpots = unicodeScalar.value - Chess.Board.CharZero
                    while emptySpots>0 {
                        let fenIndex = rankIndex * 8 + fileIndex
                        self.squares[fenIndex].clear()
                        emptySpots-=1
                        fileIndex+=1
                    }
                } else {
                    // Upper case means White pieces
                    let fenIndex = rankIndex * 8 + fileIndex
                    guard let piece = Chess.Piece.from(fen: String(fenChar)) else {
                        fatalError("FEN Character \(fenChar) invalid at: [\(fenIndex)] \(Chess.Position.from(FENIndex: fenIndex).FEN)")
                    }
                    
                    let updatedPiece: Chess.Piece
                    if !isValid(startingSquare: squares[fenIndex], for: piece) {
                        updatedPiece = Chess.Piece(side: piece.side, pieceType: piece.pieceType.pieceMoved())
                    } else {
                        updatedPiece = piece
                    }
                    
                    self.squares[fenIndex].piece = updatedPiece
                    fileIndex+=1
                }
            }
            rankIndex+=1
        }
        
        // Update the UI
        let uiUpdate = Chess.UI.Update.resetBoard(squares.map { $0.piece?.UI ?? .none })
        #warning("Hookup UI")
//        self.ui.apply(board: self, updates: [uiUpdate])
    }
}
