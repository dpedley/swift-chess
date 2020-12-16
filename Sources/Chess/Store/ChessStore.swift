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
    @Published public var game: Chess.Game
    @Published public var environment: ChessEnvironment
    private let gameSubject = PassthroughSubject<Chess.Game, Never>()
    private let gameReducer: ChessGameReducer
    private let gameSemaphore = DispatchSemaphore(value: 1)
    private let environmentSubject = PassthroughSubject<ChessEnvironment, Never>()
    private let environmentReducer: ChessEnvironmentReducer
    private let environmentSemaphore = DispatchSemaphore(value: 1)
    private var cancellables: Set<AnyCancellable> = []
    public init(
        game: Chess.Game = Chess.Game(),
        gameReducer: @escaping ChessGameReducer = ChessStore.gameReducer,
        environmentReducer: @escaping ChessEnvironmentReducer = ChessStore.environmentReducer,
        environment: ChessEnvironment = ChessEnvironment()
    ) {
        self.game = game
        self.gameReducer = gameReducer
        self.environmentReducer = environmentReducer
        self.environment = environment
        // If the initial board is empty, let's set up the pieces.
        if !self.game.board.squares.contains(where: { !$0.isEmpty }) {
            self.game.board.resetBoard()
        }
        self.game.delegate = self
    }
    public func gameAction(_ action: Chess.GameAction) {
        // Process the message on the background, then sink back to the main thread.
        DispatchQueue.global().async {
            self.gameSemaphore.wait()
            self.gamePublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] newGame in
                    self?.processGameChanges(newGame)
                    self?.gameSemaphore.signal()
                }
                .store(in: &self.cancellables)
            self.gameReducer(self.game, action, self.environment, self.gameSubject)
        }
    }
    public func environmentChange(_ change: ChessEnvironment.EnvironmentChange) {
        // Process the message on the background, then sink back to the main thread.
        DispatchQueue.global().async {
            self.environmentSemaphore.wait()
            self.environmentPublisher
                .receive(on: RunLoop.main)
                .sink { [weak self] newEnvironment in
                    self?.processEnvironmentChanges(newEnvironment)
                    self?.environmentSemaphore.signal()
                }
                .store(in: &self.cancellables)
            self.environmentReducer(self.environment, change, self.environmentSubject)
        }
    }

}

extension ChessStore {
    var gamePublisher: AnyPublisher<Chess.Game, Never> {
        gameSubject.eraseToAnyPublisher()
    }
    private func processGameChanges(_ updatedGame: Chess.Game) {
        let opposingSide = self.game.board.playingSide.opposingSide
        self.game = updatedGame
        guard opposingSide == self.game.board.playingSide else {
            // The turn didn't update, no need to continue.
            return
        }
        guard !game.userPaused else {
            return
        }
        self.gameAction(.nextTurn)
    }
}

extension ChessStore {
    var environmentPublisher: AnyPublisher<ChessEnvironment, Never> {
        environmentSubject.eraseToAnyPublisher()
    }
    private func processEnvironmentChanges(_ updatedEnvironment: ChessEnvironment) {
        self.environment = updatedEnvironment
    }
}
