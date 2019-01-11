//
//  Board.swift
//  LeelaChessZero
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

protocol Chess_PieceCoordinating: class {
    var squareForActiveKing: Chess.Square { get }
    var squares: [Chess.Square] { get }
    var positionsForOccupiedSquares: [Chess.Position] { get }
    var playingSide: Chess.Side { get }
}

extension Chess {
    class Board: Chess_PieceCoordinating {        
        private let CharZero = Unicode.Scalar("0")!.value
        static let startingFEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
        var squares: [Square] = []

        init() {
            for index in 0...63 {
                let newSquare = Square(position: Position.from(FENIndex: index))
                newSquare.board = self
                squares.append(newSquare)
            }
        }
        convenience init(FEN: String) {
            self.init()
            self.resetBoard(FEN: FEN)
        }
        var playingSide: Side = .white
        var enpassantPosition: Position? = nil
        var movesPlayed = 1 // This is intentionally 1 even at the games start.
        var FEN: String {
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
            fen += " \(playingSide.FEN) KQkq \(enpassantPosition?.FEN ?? "-") 0 \(movesPlayed)"
            return fen
        }
        
        
        
        func resetBoard(FEN: String = Chess.Board.startingFEN) {
            let FENParts = FEN.components(separatedBy: " ")
            guard FENParts.count==6, let newSide = Side(rawValue: FENParts[1]) else {
                fatalError("Invalid FEN: Cannot find active side.")
            }
            playingSide = newSide
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
                        var emptySpots = unicodeScalar.value - CharZero
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
                            fatalError("FEN Character \(fenChar) invalid at: [\(fenIndex)] \(Position.from(FENIndex: fenIndex).FEN)")
                        }
                        
                        let updatedPiece: Piece
                        if !isValid(startingSquare: squares[fenIndex], for: piece) {
                            updatedPiece = Piece(side: piece.side, pieceType: piece.pieceType.pieceMoved())
                        } else {
                            updatedPiece = piece
                        }
                        
                        self.squares[fenIndex].piece = updatedPiece
                        fileIndex+=1
                    }
                }
                rankIndex+=1
            }
        }
    }
}
