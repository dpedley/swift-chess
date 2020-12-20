//
//  SquareBackground.swift
//  
//  Created by Douglas Pedley on 12/16/20.
//
import SwiftUI

public struct SquareBackground: View {
    @EnvironmentObject public var store: ChessStore
    let position: Chess.Position
    public var body: some View {
        Rectangle() // The square background
            .fill(color(store.environment.theme.color, for: position))
            .aspectRatio(1, contentMode: .fill)
            .onDrop(of: [.plainText, .text, .utf8PlainText], delegate: self)
    }
    public func color(_ themeColor: Chess.UI.BoardColor, for position: Chess.Position) -> Color {
        let evenSquare: Bool = (position.rank + position.fileNumber) % 2 == 0
        return evenSquare ? themeColor.dark : themeColor.light
    }
    public init(_ idx: Int) {
        self.position = Chess.Position(idx)
    }
}

extension SquareBackground: DropDelegate {
    public func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    public func performDrop(info: DropInfo) -> Bool {
        store.gameAction(.userDropped(position: position))
        guard let square = store.game.board.squares.first(where: { $0.selected }) else {
            Chess.log.error("Dropped \(position.FEN) without start")
            return false
        }
        guard let piece = square.piece else {
            Chess.log.error("Dropped \(position.FEN) without piece at start")
            return false
        }
        // Try to construct the move to predict if the drop is successful
        var testMove = Chess.Move(side: piece.side,
                                  start: square.position,
                                  end: position)
        var testBoard = Chess.Board(FEN: store.game.board.FEN)
        let result = testBoard.attemptMove(&testMove)
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
}
