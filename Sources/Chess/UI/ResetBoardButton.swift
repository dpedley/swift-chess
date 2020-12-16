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
        Button {
            self.showAlert = true
        } label: {
            Image(systemName: "gobackward")
                .scaleEffect(1.5)
                .foregroundColor(.black)
        }
        .alert(isPresented: $showAlert, content: resetWarning)
    }
    public init() {}
    func resetWarning() -> Alert {
        let reset = ActionSheet.Button.default(Text("Yes")) {
            if !store.game.userPaused {
                store.gameAction(.pauseGame)
            }
            store.gameAction(.resetBoard)
        }
        let cancel = ActionSheet.Button.cancel() {}
        return Alert(title: Text("Reset Board"),
                     message: Text("Are you sure?"),
                     primaryButton: reset,
                     secondaryButton: cancel)
    }
}
