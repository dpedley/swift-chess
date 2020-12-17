//
//  Drag and drop support
//
//  Created by Douglas Pedley on 12/17/20.
//

import SwiftUI

extension View {
    func pieceDrag(_ position: Chess.Position) -> some View {
        return onDrag({
            Chess.log.info("Drag started \(position.FEN)")
            return NSItemProvider(object: position.FEN as NSString)
        })
    }
    func pieceDrop(_ position: Chess.Position, game: Chess.Game, isTargeted: Binding<Bool>? = nil) -> some View {
        return onDrop(of: [.plainText],
                      isTargeted: isTargeted,
                      perform: { providers in
                        Chess.log.info("Dropped \(position.FEN)")
            guard let provider = providers.first else {
                return false
            }
            provider.loadObject(ofClass: NSString.self,
                                completionHandler: { FEN, error in
                                    guard error == nil else {
                                        Chess.log.error("Drop error: \(error!.localizedDescription)")
                                        return
                                    }
                                    guard let FEN = FEN as? String else {
                                        return
                                    }
                                    let start = Chess.Position.from(rankAndFile: FEN)
                                    guard let piece = game.board.squares[start].piece else {
                                        // No piece to move
                                        return
                                    }
                                    let move = Chess.Move(side: piece.side, start: start, end: position)
                                    Chess.log.info("DnD Move \(move.description)")
                                    game.delegate?.gameAction(.makeMove(move: move))
                                })
            return true
        })
    }
}
