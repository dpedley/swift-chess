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
    static let playerHeight: CGFloat = 32
    static let iconEdgeOffset: CGFloat = 32
    @EnvironmentObject var store: ChessStore
    @AppStorage("muted") var muted: Bool = false
    @State var settingsVisible: Bool = false
    @AppStorage("welcomeMessage")
        var welcomeMessage: Bool = false
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
    func topPlayer(_ game: Chess.Game) -> some View {
        // top and bottom are meant to allow white and black
        // to flip sides on the board.
        let player = game.black
        return PlayerTitleView(player: player)
    }
    func bottomPlayer(_ game: Chess.Game) -> some View {
        let player = game.white
        return PlayerTitleView(player: player)
    }
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
                                        .frame(width: sheetGeometry.size.width - Self.iconEdgeOffset,
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
                   height: geometry.size.width + (Self.playerHeight * 2),
                   alignment: .center)
        }
    }
}

extension View {
    func playerFrame(_ geometry: GeometryProxy) -> some View {
        return frame(width: geometry.size.width,
                     height: BoardGameView.playerHeight)
    }
    func boardFrame(_ geometry: GeometryProxy) -> some View {
        return frame(width: geometry.size.width,
                      height: geometry.size.width)
    }
    func cornerFrame(_ geometry: GeometryProxy, alignment: Alignment) -> some View {
        return frame(width: geometry.size.width - BoardGameView.iconEdgeOffset, alignment: alignment)
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
