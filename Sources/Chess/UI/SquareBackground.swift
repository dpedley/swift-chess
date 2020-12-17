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
            .onDrop(of: [.plainText],
                    isTargeted: nil) { items in
                Chess.log.info("Dropped \(position.FEN)")
                guard let item = items.first else {
                    return false
                }
                item.loadObject(ofClass: NSString.self,
                                completionHandler: { FEN, error in
                                    guard error == nil else {
                                        Chess.log.error("Drop error: \(error!.localizedDescription)")
                                        return
                                    }
                                    guard let FEN = FEN as? String else {
                                        return
                                    }
                                    let start = Chess.Position.from(rankAndFile: FEN)
                                    guard let piece = store.game.board.squares[start].piece else {
                                        // No piece to move
                                        return
                                    }
                                    let move = Chess.Move(side: piece.side, start: start, end: position)
                                    Chess.log.info("DnD Move \(move.description)")
                                    store.gameAction(.makeMove(move: move))
                                })
                return true
      }
    }
    public func color(_ themeColor: Chess.UI.BoardColor, for position: Chess.Position) -> Color {
        let evenSquare: Bool = (position.rank + position.fileNumber) % 2 == 0
        return evenSquare ? themeColor.dark : themeColor.light
    }
    public init(_ idx: Int) {
        self.position = Chess.Position(idx)
    }
}
