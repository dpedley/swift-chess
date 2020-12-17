//
//  Drag and drop support
//
//  Created by Douglas Pedley on 12/17/20.
//

import SwiftUI

extension View {
    func pieceDrag(_ idx: Int) -> some View {
        return onDrag({
            let position = Chess.Position(idx)
            Chess.log.info("Drag started \(position.FEN)")
            return NSItemProvider(object: position.FEN as NSString)
        })
    }
    func pieceDrop(_ idx: Int, isTargeted: Binding<Bool>? = nil) -> some View {
        return onDrop(of: [.plainText],
                      isTargeted: isTargeted,
                      perform: { providers in
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
                                    let position = Chess.Position.from(rankAndFile: FEN)
                                    Chess.log.info("Dropped \(position.FEN)")
                                })
            return true
        })
    }
}
