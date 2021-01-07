//
//  BoardGameView.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/16/20.
//

import Foundation
import SwiftUI
import Chess

struct BoardGameView: View {
    @EnvironmentObject var store: ChessStore
    @AppStorage("welcomeMessage") var welcomeMessage = false
    @State var settingsVisible = false
    var body: some View {
        // This view combines the chess board with
        // some common controls and game indicators
        GeometryReader { geometry in
            VStack {
                // Top player area
                ZStack {
                    self.topPlayer(store.game)
                        .frame(alignment: .center)
                    ChessSettingsButton {
                        self.settingsVisible = true
                    }
                    .cornerFrame(geometry, alignment: .trailing)
                    .sheet(isPresented: $settingsVisible) {
                        GeometryReader { sheetGeometry in
                            VStack {
                                Button {
                                    self.settingsVisible = false
                                } label: {
                                    Image(systemName: "xmark")
                                        .accentColor(.primary)
                                        .frame(width: sheetGeometry.size.width - 32,
                                               alignment: .trailing)
                                }
                                .padding()
                                Spacer()
                                ChessSettingsView {
                                    debugMenu()
                                }
                            }
                            .background(Color(UIColor.systemGroupedBackground))
                        }
                    }
                }
                .playerFrame(geometry)
                // The chess board
                BoardView()
                    .boardFrame(geometry)
                // Bottom player area
                ZStack {
                    ResetBoardButton()
                        .cornerFrame(geometry, alignment: .leading)
                    self.bottomPlayer(store.game)
                    PlayPauseButton()
                        .cornerFrame(geometry, alignment: .trailing)
                }
                .playerFrame(geometry)
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.width + 64,
                   alignment: .center)
        }
    }
}

struct BoardGameViewPreview: PreviewProvider {
    static let store: ChessStore = {
        let white = Chess.HumanPlayer(side: .white)
        let black = Chess.Robot.CautiousBot(side: .black)
        let game = Chess.Game(white, against: black)
        let store = ChessStore(game: game)
        return store
    }()
    static var previews: some View {
        VStack {
            BoardGameView()
                .environmentObject(store)
        }
    }
}
