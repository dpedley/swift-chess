//
//  Board+FEN.swift
//
//  Created by Douglas Pedley on 1/11/19.
//

import Foundation

public extension Chess.Board {
    static let startingFEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    var FEN: String { return createCurrentFENString() }
    mutating func resetBoard(FEN: String = Chess.Board.startingFEN) {
        turns.removeAll()
        repetitionMap.removeAll()
        let FENParts = FEN.components(separatedBy: " ")
        guard FENParts.count==6, let newSide = Chess.Side(rawValue: FENParts[1]) else {
            Chess.log.critical("Invalid FEN: Cannot find active side.")
            return
        }
        let castlingRights = FENParts[2]
        parseCastlingString(castlingRights)
        guard let drawCount = Int(FENParts[4]) else {
            Chess.log.critical("Invalid FEN: Cannot parse fiftyRuleCount \(FENParts[4]).")
            return
        }
        fiftyMovesCount = drawCount
        guard let moveCount = Int(FENParts[5]) else {
            Chess.log.critical("Invalid FEN: Cannot parse fullmoves \(FENParts[5]).")
            return
        }
        fullMoves = moveCount
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
        let castles = createCastlingString()
        let enPassant = enPassantPosition?.FEN ?? "-"
        fen += " \(playingSide.FEN) \(castles) \(enPassant) \(fiftyMovesCount) \(fullMoves)"
        return fen
    }
    private mutating func parseCastlingString(_ castling: String) {
        guard castling.count > 0, castling != "-" else {
            blackCastleKingSide = false
            blackCastleQueenSide = false
            whiteCastleKingSide = false
            whiteCastleQueenSide = false
            return
        }
        blackCastleKingSide = castling.contains("k")
        blackCastleQueenSide = castling.contains("q")
        whiteCastleKingSide = castling.contains("K")
        whiteCastleQueenSide = castling.contains("Q")
    }
    private func createCastlingString() -> String {
        var castling = ""
        // whiteKing = .e1
        if whiteCastleKingSide == true { castling += "K" }
        if whiteCastleQueenSide == true { castling += "Q" }
        if blackCastleKingSide == true { castling += "k" }
        if blackCastleQueenSide == true { castling += "q" }
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
                self.squares[fenIndex].piece = piece
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
