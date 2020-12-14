//
//  File.swift
//  
//
//  Created by Douglas Pedley on 12/8/20.
//

import Foundation

extension Chess {
    enum Rules {
        static func isValidKingMove(_ move: Chess.Move, hasMoved: Bool) throws -> Bool {
            guard move.rankDistance != 0 || move.fileDistance != 0 else { return false }
            if move.rankDistance<2, move.fileDistance<2 {
                // Not a castling, and only 1 square in any direction, looks good.
                return true
            }
            // Are we trying to castle?
            if !hasMoved, move.rankDistance == 0, move.fileDistance == 2 {
                let rookDistance = move.fileDirection < 0 ? 2 : 1
                let rook = move.end + (move.fileDirection * rookDistance)
                // Note "move.end - move.fileDirection" is always the square the king passes over when castling.
                throw Chess.Move.SideEffect.castling(rook: rook, destination: move.end - move.fileDirection)
            }
            return false
        }
        static func isValidQueenMove(_ move: Chess.Move) -> Bool {
            guard isValidRookMove(move) || isValidBishopMove(move) else { return false }
            return true
        }
        static func isValidRookMove(_ move: Chess.Move) -> Bool {
            guard move.rankDistance != 0 || move.fileDistance != 0 else { return false }
            guard move.rankDistance == 0 || move.fileDistance == 0 else { return false }
            return true
        }
        static func isValidKnightMove(_ move: Chess.Move) -> Bool {
            guard move.rankDistance != 0 || move.fileDistance != 0 else { return false }
            if (move.rankDistance==2 && move.fileDistance==1) ||
                (move.rankDistance==1 && move.fileDistance==2) {
                return true
            }
            return false
        }
        static func isValidBishopMove(_ move: Chess.Move) -> Bool {
            guard move.rankDistance != 0 || move.fileDistance != 0 else { return false }
            guard move.rankDistance == move.fileDistance else { return false }
            return true
        }
        static func isValidPawnMove(_ move: Chess.Move, hasMoved: Bool) throws -> Bool {
            guard move.rankDistance != 0 || move.fileDistance != 0 else { return false }
            // Only forward
            if move.rankDirection == move.side.rankDirection {
                if move.rankDistance == 1, move.fileDistance == 0 { // Plain vanilla pawn move
                    return true
                }
                if move.rankDistance == 2, move.fileDistance == 0 {
                    // Two step is only allow as the first move
                    if hasMoved {
                        return false
                    }
                    // a two step pawn move is only valid from the pawn's initial rank
                    guard move.start.rank == move.side.pawnsInitialRank else {
                        return false
                    }
                    // The move is valid. Before we return, make sure to attach the enPassantPosition
                    let jumpPosition = (move.start + move.end) / 2
                    throw Chess.Move.SideEffect.enPassantInvade(territory: jumpPosition, invader: move.end)
                }
            }
            return false
        }
        static var startingPositionsForBlackPawns: [Chess.Position] = [.a7, .b7, .c7, .d7, .e7, .f7, .g7, .h7]
        static var startingPositionsForWhitePawns: [Chess.Position] = [.a2, .b2, .c2, .d2, .e2, .f2, .g2, .h2]
        static var startingPositionsForBlackKnights: [Chess.Position] = [.b8, .g8]
        static var startingPositionsForWhiteKnights: [Chess.Position] = [.b1, .g1]
        static var startingPositionsForBlackBishops: [Chess.Position] = [.c8, .f8]
        static var startingPositionsForWhiteBishops: [Chess.Position] = [.c1, .f1]
        static var startingPositionsForBlackRooks: [Chess.Position] = [.a8, .h8]
        static var startingPositionsForWhiteRooks: [Chess.Position] = [.a1, .h1]
        static func startingPositionForRook(side: Chess.Side, kingSide: Bool) -> Chess.Position {
            if side == .white {
                return kingSide ? .h1 : .a1
            }
            return kingSide ? .h8 : .a8
        }
    }
}
