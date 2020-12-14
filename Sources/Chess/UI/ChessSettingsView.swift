//
//  ChessSettingsView.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//
import Foundation
import SwiftUI

public struct ChessSettingsView: View {
    @EnvironmentObject public var store: ChessStore
    public var body: some View {
        VStack {
            ChessPlayerMenu()
                .environmentObject(store)
            ChessBoardColorMenu()
                .environmentObject(store)
        }
    }
    public init() {}
}

struct ChessSettingsViewPreviews: PreviewProvider {
    static var previews: some View {
        VStack {
            Menu("Settings") {
                ChessSettingsView().environmentObject(previewChessStore)
            }
            Spacer()
            ChessSettingsView()
                .environmentObject(previewChessStore)
        }
    }
}
