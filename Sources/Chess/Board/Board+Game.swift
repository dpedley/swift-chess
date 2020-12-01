//
//  Board+Game.swift
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
        guard let square = findOptionalKing(side) else {
            fatalError("Tried to access the \(side) king when it wasn't on the board [\(FEN)]")
        }
        return square
    }
    
    internal func findOptionalKing(_ side: Chess.Side) -> Chess.Square? {
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
        return kingSearch
    }
    
    func prepareMove(_ move: inout Chess.Move) -> Chess.Move.Result? {
        let fromSquare = squares[move.start]
        let toSquare = squares[move.end]
        guard let piece = fromSquare.piece else {
            return .failed(reason: .noPieceToMove)
        }
        
        guard let toPiece = toSquare.piece else {
            // The square we are moving to is empty, check that it's a valid move.
            guard piece.isMoveValid(&move, board: self) else {
                return .failed(reason: .invalidMoveForPiece)
            }
            return nil
        }
        guard piece.side != toPiece.side else {
            return .failed(reason: .sameSideAlreadyOccupiesDestination)
        }
        guard piece.isAttackValid(&move, board: self) else {
            return .failed(reason: .invalidAttackForPiece)
        }
        return nil
    }
    
    mutating func allSquaresAttacking(_ targetSquare: Chess.Square, side: Chess.Side, applyVariants: Bool) -> [Chess.Square] {
        var attackers: [Chess.Square] = []
        for square in squares {
            guard let piece = square.piece, piece.side == side else { continue }
            var attack = Chess.Move(side: side, start: square.position, end: targetSquare.position)
            var tmpBoard = Chess.Board(FEN: self.FEN)
            tmpBoard.playingSide = side
            let result = tmpBoard.attemptMove(&attack, applyVariants: applyVariants)
            switch result {
            case .success:
                attackers.append(square)
            default:
                break
            }
        }
        return attackers
    }
    
    // Returns false if move cannot be made
    mutating func attemptMove(_ move: inout Chess.Move, applyVariants: Bool = true) -> Chess.Move.Result {
        if let failedResult = prepareMove(&move) { return failedResult }
        
        // We need to attempt the move and see if it produces a board where the king is under attack.
        if applyVariants {
            let boardChange = Chess.BoardChange.moveMade(move: move)
            let testVariant = Chess.SingleMoveVariant(originalFEN: self.FEN, changesToAttempt: [boardChange], deepVariant: false)
            // Are we defending the king properly?
            if let kingSquare = testVariant.board.findOptionalKing(move.side) {
                let attackers = testVariant.board.allSquaresAttacking(kingSquare, side: move.side.opposingSide, applyVariants: false)
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
        commit(move, capturedPiece: capturedPiece)
        
        return .success(capturedPiece: capturedPiece)
    }
    
    // Crashes if the move cannot be made, vet using attemptMove first.
    mutating func commit(_ move: Chess.Move, capturedPiece: Chess.Piece?)  {
        guard let movingPiece = squares[move.start].piece else {
            fatalError("Cannot move, no piece.")
        }
        guard movingPiece.side == playingSide else {
            fatalError("Error, \(movingPiece.side) cannot move, it's \(playingSide)'s turn.")
        }

        var unicodeString: String?
        var pgnString: String?
        var piece = movingPiece
        
        // When pawns move to their last rank, we need a promotion side effect
        // we default to queen promotion if none is given.
        if piece.isLastRank(move.end), move.sideEffect.isUnknown {
            move.sideEffect = .promotion(piece: .init(side: piece.side, pieceType: .queen(hasMoved: true)))
        }

        switch move.sideEffect {
        case .notKnown:
            fatalError("Cannot commit move, it's side effect is unknown. \(move)")
        case .castling(let rookIndex, let destinationIndex):
            // We need to also move the rook
            guard let rook = squares[rookIndex].piece, rook.pieceType.isRook(),
                  rook.side == move.side else {
                    fatalError("Cannot castle without a rook")
            }
            guard squares[destinationIndex].isEmpty else {
                fatalError("Destination must be empty when castling \(move)")
            }
            unicodeString = (squares[rookIndex].isKingSide) ? "O-O" : "O-O-O"
            pgnString = unicodeString
            squares[rookIndex].clear()
            squares[destinationIndex].piece = rook
        case .promotion(let promotedPiece):
            // omg we're getting an upgrade.
            piece = promotedPiece
            let captureBase = (capturedPiece != nil) ? "\(move.start.file)x" : ""
            unicodeString = "\(captureBase)\(move.end.FEN)=\(promotedPiece.unicode)"
            pgnString = "\(captureBase)\(move.end.FEN)=\(promotedPiece.FEN)"
        case .enPassantInvade(_, _):
            // This is handled by lastMove. We check that later to see if the invader double stepped.
            break
        case .enPassantCapture(_, _):
            // This was handled before the commit, see capturedPiece.
            unicodeString = "\(move.start.file)x\(move.end)"
            pgnString = unicodeString
            break
        case .noneish:
            // Do nothing ish
            break
        }
        
        squares[move.start].clear()
        squares[move.end].piece = piece
        if unicodeString == nil {
            switch movingPiece.pieceType {
            case .pawn(_):
                unicodeString = (capturedPiece != nil) ? "\(move.start.file)x\(move.end.FEN)" : "\(move.end.FEN)"
                pgnString = unicodeString
            case .knight(_), .bishop(_), .rook(_, _), .queen(_), .king(_):
                let unicodeCapture: String = (capturedPiece != nil) ? "x" : ""
                unicodeString = "\(piece.unicode)\(unicodeCapture)\(move.end.FEN)"
                pgnString = "\(piece.FEN)\(unicodeCapture)\(move.end.FEN)"
            }
        }
        move.unicodePGN = unicodeString
        move.PGN = pgnString
        
        
        if playingSide == .black {
            if turns.count == 0 {
                // This should only happen in board variants.
                turns.append(Chess.Turn(white: move, black: nil))
            } else {
                // This is the usual black move follows white, so the turn exists in the stack.
                turns[turns.count - 1].black = move
            }
            
            fullMoves += 1
        } else {
            turns.append(Chess.Turn(white: move, black: nil))
        }
        
        playingSide = playingSide.opposingSide
    }
}
