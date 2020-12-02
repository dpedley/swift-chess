//
//  Chess.swift
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// Our namespace
public enum Chess { }

struct Chess_Preview: PreviewProvider {
    static var previewCounter = 0
    static var sampleStore: ChessStore = {
        let store = ChessStore(initialGame: Chess.Game.sampleGame())
        store.game.userPaused = true
        return store
    }()
    static var previews: some View {
        GeometryReader { geometry in
            HStack {
                BoardView()
                    .environmentObject(sampleStore)
                VStack {
                    Button("Play \(sampleStore.game.activePlayer?.lastName ?? "") next move") {
                        previewCounter += 1
                        sampleStore.send(.nextTurn)
                    }
                    Text("Count: \(previewCounter)")
                }
            }
        }
    }
}
