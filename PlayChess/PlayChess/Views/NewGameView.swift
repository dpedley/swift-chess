//
//  NewGameView.swift
//  PlayChess
//
//  Created by Douglas Pedley on 1/2/21.
//

import Foundation
import Chess
import SwiftUI

struct NewGameView: View {
    @EnvironmentObject var store: ChessStore
    var startMessage: String {
        guard store.game.white is Chess.HumanPlayer else {
            return "Start the game with the play icon"
        }
        return "Make your first more to start the game"
    }
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                RobotPlacard(store.game.white)
                RobotPlacard(store.game.black)
            }
            Spacer()
            Text("\(startMessage),")
                .font(.footnote)
                .fontWeight(.ultraLight)
            Text("or change settings using the gear icon")
                .font(.footnote)
                .fontWeight(.ultraLight)
            Spacer()
        }
    }
}

struct NewGameViewPreview: PreviewProvider {
    static var store: ChessStore = {
        var white = Chess.HumanPlayer(side: .white)
        let black = Chess.Robot.CautiousBot(side: .black)
        let game = Chess.Game(white, against: black)
        let store = ChessStore(game: game)
        Chess.soundDelegate = nil
        return store
    }()
    static var previews: some View {
        ContentView().environmentObject(store)
    }
}
