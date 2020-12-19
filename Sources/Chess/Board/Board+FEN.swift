//
//  Board+FEN.swift
//
//  Created by Douglas Pedley on 1/11/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

public extension Chess.Board {
    static let startingFEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    var FEN: String { return createCurrentFENString() }
    mutating func resetBoard(FEN: String = Chess.Board.startingFEN) {
        turns.removeAll()
        let FENParts = FEN.components(separatedBy: " ")
        guard FENParts.count==6, let newSide = Chess.Side(rawValue: FENParts[1]) else {
            Chess.log.critical("Invalid FEN: Cannot find active side.")
            return
        }
        guard let moveCount = Int(FENParts[5]) else {
            Chess.log.critical("Invalid FEN: Cannot parse fullmoves \(FENParts[5]).")
            return
        }
        // Still UNDONE: castling checks in the hasMoved below
        // en passant square last move side effect additions
        guard let piecesString = FENParts.first else {
            Chess.log.critical("Invalid FEN")
            return
        }
        let ranks = piecesString.components(separatedBy: "/")
        guard ranks.count==8 else {
            Chess.log.critical("Invalid FEN")
            return
        }
        fullMoves = moveCount
        var rankIndex = 0
        for rankString in ranks {
            processFENRankString(rankString, rankIndex: rankIndex)
            rankIndex+=1
        }
        playingSide = newSide
    }
}

extension Chess.Board {
    private func createCurrentFENString() -> String {
        var fen = ""
        var emptyCount = 0
        for square in squares {
            fen += square.createCurrentFENString(&emptyCount)
        }
        fen += " \(playingSide.FEN) \(createCastlingString()) \(enPassantPosition?.FEN ?? "-") 0 \(fullMoves)"
        return fen
    }
    private func createCastlingString() -> String {
        var castling = ""
        // whiteKing = .e1
        if squares[.e1].piece?.hasMoved == false {
            if squares[.h1].piece?.hasMoved == false { castling += "K" }
            if squares[.a1].piece?.hasMoved == false { castling += "Q" }
        }
        // blackKing = .e8
        if squares[.e8].piece?.hasMoved == false {
            if squares[.h8].piece?.hasMoved == false { castling += "k" }
            if squares[.a8].piece?.hasMoved == false { castling += "q" }
        }
        if castling.count == 0 { castling = "-" }
        return castling
    }
}
/// Board FEN hydration
extension Chess.Board {
    private static let CharZero = Unicode.Scalar("0").value
    mutating private func processFENRankString(_ rankString: String, rankIndex: Int) {
        var fileIndex = 0
        for fenChar in rankString {
            guard let unicodeScalar = fenChar.unicodeScalars.first else {
                // unicodeScalar error?
                Chess.log.critical("FEN Character \(fenChar) invalid")
                return
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
                    Chess.log.critical("FEN Character \(fenChar) invalid at: \(Chess.Position(fenIndex).FEN)")
                    return
                }
                let updatedPiece: Chess.Piece
                if isValid(startingSquare: squares[fenIndex], for: piece) {
                    updatedPiece = piece
                } else {
                    var movedPiece = piece
                    movedPiece.pieceType = piece.pieceType.pieceMoved()
                    updatedPiece = movedPiece
                }
                self.squares[fenIndex].piece = updatedPiece
                fileIndex+=1
            }
        }
    }
    func isValid(startingSquare square: Chess.Square, for piece: Chess.Piece) -> Bool {
        switch piece.pieceType {
        case .pawn:
            return piece.side == .black ? square.position.rank==7 : square.position.rank==2
        case .knight:
            return piece.side == .black ?
                Chess.Rules.startingPositionsForBlackKnights.contains(square.position) :
                Chess.Rules.startingPositionsForWhiteKnights.contains(square.position)
        case .bishop:
            return piece.side == .black ?
                Chess.Rules.startingPositionsForBlackBishops.contains(square.position) :
                Chess.Rules.startingPositionsForWhiteBishops.contains(square.position)
        case .rook:
            return piece.side == .black ?
                Chess.Rules.startingPositionsForBlackRooks.contains(square.position) :
                Chess.Rules.startingPositionsForWhiteRooks.contains(square.position)
        case .queen:
            return piece.side == .black ? square.position == .d8 : square.position == .d1
        case .king:
            return piece.side == .black ? square.position == .e8 : square.position == .e1
        }
    }
}
