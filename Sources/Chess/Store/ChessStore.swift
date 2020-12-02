//
//  File.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI
import Combine

final class ChessStore: ObservableObject, ChessGameDelegate {
    @Published var game: ChessGame
    var theme: Chess.UI.ChessTheme {
        environment.theme
    }
    private let environment: ChessEnvironment
    private let reducer: ChessGameReducer<ChessGame, ChessAction, ChessEnvironment>
    private var cancellables: Set<AnyCancellable> = []

    init(
        initialGame: ChessGame,
        reducer: @escaping ChessGameReducer<ChessGame, ChessAction, ChessEnvironment> = ChessStore.chessReducer,
        environment: ChessEnvironment = ChessEnvironment()
    ) {
        self.game = initialGame
        self.reducer = reducer
        self.environment = environment
        // If the initial board is empty, let's set up the pieces.
        if !game.board.squares.contains(where: { !$0.isEmpty }) {
            game.board.resetBoard()
        }
        game.delegate = self
    }

    func send(_ action: ChessAction) {
        guard let effect = reducer(&game, action, environment) else {
            return
        }

        effect
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }
}
