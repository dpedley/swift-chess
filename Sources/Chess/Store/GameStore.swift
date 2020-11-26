//
//  File.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import SwiftUI
import Combine

struct ChessEnvironment {
    enum TargetEnvironment {
        case production
        case development
    }
    var target: TargetEnvironment = .development
}

@available(iOS 14.0, *)
struct ChessState {
    var player: Chess.Player
    var opponent: Chess.Player
    var game: Chess.Game
    var theme = Chess.UI.ChessTheme()
    init(player: Chess.Player? = nil, opponent: Chess.Player? = nil) {
        let player: Chess.Player = player ?? Chess.Player(side: .white, matchLength: 60)
        let opponent: Chess.Player = opponent ?? Chess.Player(side: player.side.opposingSide, matchLength: 60)
        self.player = player
        self.opponent = opponent
        self.game = Chess.Game(player, against: opponent)
    }
}

typealias ChessStateReducer<State, Action, Environment> =
    (inout State, Action, Environment) -> AnyPublisher<Action, Never>?

final class Store<State, Action, Environment>: ObservableObject {
    @Published private(set) var state: State

    private let environment: Environment
    private let reducer: ChessStateReducer<State, Action, Environment>
    private var cancellables: Set<AnyCancellable> = []

    init(
        initialState: State,
        reducer: @escaping ChessStateReducer<State, Action, Environment>,
        environment: Environment
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    func send(_ action: Action) {
        guard let effect = reducer(&state, action, environment) else {
            return
        }

        effect
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }
}

enum ChessAction {
    case startGame
    case setBoard(fen: String)
}

@available(iOS 14.0, *)
typealias ChessStore = Store<ChessState, ChessAction, ChessEnvironment>

@available(iOS 14.0, *)
extension App {
    static func chessReducer(
        state: inout ChessState,
        action: ChessAction,
        environment: ChessEnvironment
    ) -> AnyPublisher<ChessAction, Never>? {
        switch action {
        case .startGame:
            print("start game")
        case .setBoard(fen: let fen):
            print("set board with fen \(fen)")
            state.game.board.resetBoard(FEN: fen)
        }
        return nil
    }
}

@available(iOS 14.0, *)
extension PreviewProvider {
    static func previewChessReducer(state: inout ChessState, action: ChessAction, environment: ChessEnvironment) -> AnyPublisher<ChessAction, Never>? {
        return nil
    }
    static var previewChessStore: ChessStore {
        let store = ChessStore(initialState: ChessState(),
                                       reducer: previewChessReducer, environment: ChessEnvironment(target: .development))
        store.state.game.board.resetBoard()
        return store
    }
}
