//
//  ResetBoardButton.swift
//  
//
//  Created by Douglas Pedley on 12/16/20.
//

import Foundation
import SwiftUI

public struct ResetBoardButton: View {
    @EnvironmentObject public var store: ChessStore
    @State private var showAlert: Bool = false
    public var body: some View {
        guard !store.game.board.turns.isEmpty else {
            return AnyView(EmptyView())
        }
        let button = Button {
            if !store.game.userPaused {
                store.gameAction(.pauseGame)
            }
            self.showAlert = true
        } label: {
            Image(systemName: "gobackward")
                .foregroundColor(.black)
        }
        .alert(isPresented: $showAlert, content: resetWarning)
        return AnyView(button)
    }
    public init() {}
    func resetWarning() -> Alert {
        let reset = Alert.Button.default(Text("Yes")) {
            store.gameAction(.resetBoard)
        }
        let cancel = Alert.Button.cancel {}
        return Alert(title: Text("Reset Board"),
                     message: Text("Are you sure?"),
                     primaryButton: reset,
                     secondaryButton: cancel)
    }
}
