//
//  Board+Game.swift
//  LeelaChessZero
//
//  Created by Douglas Pedley on 1/6/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

extension Chess.Board  {
    internal func lastEnPassantPosition() -> Chess.Position? {
        guard let sideEffect = lastMove?.sideEffect else { return nil }
        switch sideEffect {
        case Chess.Move.SideEffect.enPassantInvade(let territory, _):
            return territory
        default:
            return nil
        }
    }

    internal func findKing(_ side: Chess.Side) -> Chess.Square {
        var kingSearch: Chess.Square? = nil
        squares.forEach {
            if let piece = $0.piece, piece.side == side {
                switch piece.pieceType {
                case .king:
                    kingSearch = $0
                default:
                    break
                }
            }
        }
        guard let square = kingSearch else {
            fatalError("Tried to access the \(side) king when it wasn't on the board [\(FEN)]")
        }
        return square
    }
    
    func prepareMove(_ move: Chess.Move) -> Chess.Move.Result? {
        let fromSquare = squares[move.start]
        let toSquare = squares[move.end]
        guard let piece = fromSquare.piece else { return .failed(reason: .noPieceToMove) }
        guard piece.side != toSquare.piece?.side else { return .failed(reason: .sameSideAlreadyOccupiesDestination) }
        
        if let _ = toSquare.piece {
            guard piece.isAttackValid(move) else { return .failed(reason: .invalidAttackForPiece) }
        } else {
            guard piece.isMoveValid(move, board: self) else { return .failed(reason: .invalidMoveForPiece) }
        }
        return nil
    }
    
    // Returns false if move cannot be made
    func attemptMove(_ move: Chess.Move) -> Chess.Move.Result {
        if let failedResult = prepareMove(move) { return failedResult }
        
        // We need to attempt the move and see if it produces a board where the king is under attack.
        let testVariant = variant(with: move)
        
        // Are we defending the king properly?
        let kingSquare = testVariant.board.squareForActiveKing
        let attackers = kingSquare.allSquaresWithValidAttackingPieces
        if attackers.count>0 {
            
            guard let loneAttacker = attackers.first else {
                // Logic problem here
                return .failed(reason: .unknown)
            }
            
            // There should be at least one, because `kingSquare.isUnderAttack`, but if there is more than one the move will not solve check
            if attackers.count>1 {
                return .failed(reason: .kingWouldBeUnderAttackAfterMove)
            }
            
            // There is only one attacker, but we are only a defender if this move takes out the attacker.
            if loneAttacker.position.rank != move.end.rank || loneAttacker.position.file != move.end.file {
                return .failed(reason: .kingWouldBeUnderAttackAfterMove)
            }
        }
        
        // The move passed our tests, we can commit it safely
        move.setVerified()
        
        // Before we `commit` the move grab the destination square's piece (if there is one) `commit` will over write it.
        // We do this with the special EnPassant capture as well.
        let capturedPiece: Chess.Piece?
        switch move.sideEffect {
        case .enPassantCapture(_, let trespasser):
            capturedPiece = squares[trespasser].piece
        default:
            capturedPiece = squares[move.end].piece
        }
        commit(move)
        
        return .success(capturedPiece: capturedPiece)
    }
    
    // Crashes if the move cannot be made, vet using attemptMove first.
    func commit(_ move: Chess.Move)  {
        guard let piece = squares[move.start].piece else {
            fatalError("Cannot move, no piece.")
        }
        guard piece.side == playingSide else {
            fatalError("Error, \(piece.side) cannot move, it's \(playingSide)'s turn.")
        }

        switch move.sideEffect {
        case .notKnown:
            fatalError("Cannot commit move, it's side effect is unknown. \(move)")
        case .simulating:
            guard let _ = self as? Chess.BoardSimulation else {
                fatalError("Simulating moves is only unsafe on our root board.")
            }
        case .castling(let rookIndex, let destinationIndex):
            // We need to also move the rook
            let rookSquare = squares[rookIndex]
            let destinationSquare = squares[destinationIndex]
            guard let rook = rookSquare.piece else { fatalError("Cannot castle without a rook") } // Should we check type and side as well?
            guard destinationSquare.isEmpty else {
                fatalError("Destination must be empty when castling \(move)")
            }
            rookSquare.clear()
            destinationSquare.piece = rook
        case .enPassantInvade(_, _):
            // This is handled by lastMove. We check that later to see if the invader double stepped.
            break
        case .enPassantCapture(_, _):
            // This was handled before the commit, see capturedPiece.
            break
        case .noneish:
            // Do nothing ish
            break
        }
        
        squares[move.start].clear()
        squares[move.end].piece = piece
        
        lastMove = move        
        if playingSide == .black {
            fullMoves += 1
        }
        
        playingSide = playingSide.opposingSide
        
    }
}
