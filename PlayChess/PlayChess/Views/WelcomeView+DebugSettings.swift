//
//  WelcomeView+DebugSettings.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/16/20.
//

import SwiftUI

extension BoardGameView {
    func debugMenu() -> AnyView {
        guard store.environment.target == .development else {
            return AnyView(EmptyView())
        }
        return AnyView(
            Section(header: Text("Development Settings")) {
                Toggle(isOn: $welcomeMessage, label: {
                    Text("Show the welcome screen")
                })

            }
        )
    }
}
