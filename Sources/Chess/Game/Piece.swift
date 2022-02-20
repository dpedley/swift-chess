//
//  Piece.swift
//
//  Created by Douglas Pedley on 1/5/19.
//

import Foundation

public extension Chess {
    struct Piece: Identifiable, Equatable {
        public static func == (lhs: Piece, rhs: Piece) -> Bool {
            return lhs.pieceType.fen() == rhs.pieceType.fen()
        }
        public let id = UUID()
        public let side: Side
        public var pieceType: PieceType
        public var FEN: String {
            switch side {
            case .black:
                return pieceType.fen(.black)
            case .white:
                return pieceType.fen(.white)
            }
        }
        // swiftlint:disable identifier_name
        public let UI: PieceGlyph // Let's revisit this name
        // swiftlint:enable identifier_name
        public init(side: Side, pieceType: PieceType) {
            self.side = side
            self.pieceType = pieceType
            self.UI = Chess.PieceGlyph(side: side, pieceType: pieceType)
        }
        public static func from(fen: String) -> Piece? {
            guard fen.count == 1 else {
                Chess.log.critical("Couldn't create a piece from [\(fen)]")
                return nil
            }
            let lower = fen.lowercased()
            let side: Side = (lower == fen) ? .black : .white
            var foundType: PieceType?
            if lower == "p" {
                foundType = .pawn
            } else if lower == "n" {
                foundType = .knight
            } else if lower == "b" {
                foundType = .bishop
            } else if lower == "r" {
                foundType = .rook
            } else if lower == "q" {
                foundType = .queen
            } else if lower == "k" {
                foundType = .king
            }
            guard let pieceType = foundType else {
                return nil
            }
            return Piece(side: side, pieceType: pieceType)
        }
        public var unicode: String {
            switch self.pieceType {
            case .pawn:
                return side == .black ? "\u{265F}" : "\u{2659}"
            case .knight:
                return side == .black ? "\u{265E}" : "\u{2658}"
            case .bishop:
                return side == .black ? "\u{265D}" : "\u{2657}"
            case .rook:
                return side == .black ? "\u{265C}" : "\u{2656}"
            case .queen:
                return side == .black ? "\u{265B}" : "\u{2655}"
            case .king:
                return side == .black ? "\u{265A}" : "\u{2654}"
            }
        }
        /// Sourced here:https://en.wikipedia.org/wiki/Chess_piece_relative_value
        /// Went with AlphaZero - 1.0 3.05    3.33    5.63    9.5
        public var weight: Double {
            switch self.pieceType {
            case .pawn:
                return 1.0
            case .knight:
                return 3.05
            case .bishop:
                return 3.33
            case .rook:
                return 5.63
            case .queen:
                return 9.5
            case .king:
                return 0.0
            }
        }
        public var artwork: PieceArtwork {
            switch self.pieceType {
            case .pawn:
                return .pawn
            case .knight:
                return .knight
            case .bishop:
                return .bishop
            case .rook:
                return .rook
            case .queen:
                return .queen
            case .king:
                return .king
            }
        }
        public var style: PieceStyle {
            return side == .black ? .black : .white
        }
    }
}
