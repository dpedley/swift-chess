//
//  ChessStore.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI
import Combine

public final class ChessStore: ObservableObject, ChessGameDelegate {
    let passThrough = PassthroughSubject<Chess.Game, Never>()
    var gamePublisher: AnyPublisher<Chess.Game, Never> {
        passThrough.eraseToAnyPublisher()
    }
    @Published public var game: Chess.Game
    private let environment: ChessEnvironment
    private let reducer: ChessGameReducer
    private var cancellables: Set<AnyCancellable> = []
    var theme: Chess.UI.ChessTheme {
        environment.theme
    }
    public init(
        game: Chess.Game = Chess.Game(),
        reducer: @escaping ChessGameReducer = ChessStore.chessReducer,
        environment: ChessEnvironment = ChessEnvironment()
    ) {
        self.game = game
        self.reducer = reducer
        self.environment = environment
        // If the initial board is empty, let's set up the pieces.
        if !self.game.board.squares.contains(where: { !$0.isEmpty }) {
            self.game.board.resetBoard()
        }
        self.game.delegate = self
    }
    func processChanges(_ updatedGame: Chess.Game) {
        let opposingSide = self.game.board.playingSide.opposingSide
        self.game = updatedGame
        guard opposingSide == self.game.board.playingSide else {
            // The turn didn't update, no need to continue.
            return
        }
        guard !game.userPaused else {
            return
        }
        self.send(.nextTurn)
    }
    public func send(_ action: ChessAction) {
        // Process the message on the background, then sink back to the main thread.
        DispatchQueue.global().async {
            self.gamePublisher
                .debounce(for: .milliseconds(1), scheduler: RunLoop.main)
                .receive(on: RunLoop.main)
                .sink { [weak self] newGame in
                    self?.processChanges(newGame)
                }
                .store(in: &self.cancellables)
            self.reducer(self.game, action, self.environment, self.passThrough)
        }
    }
}
