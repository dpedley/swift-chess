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
    @Published var game: Chess.Game
    var theme: Chess.UI.ChessTheme {
        environment.theme
    }
    private let environment: ChessEnvironment
    private let reducer: ChessGameReducer<Chess.Game, ChessAction, ChessEnvironment>
    private var cancellables: Set<AnyCancellable> = []

    init(
        game: Chess.Game,
        reducer: @escaping ChessGameReducer<Chess.Game, ChessAction, ChessEnvironment> = ChessStore.chessReducer,
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

    func send(_ action: ChessAction) {
        let queue = DispatchQueue(label: "ChessReducer")
        queue.async {
            guard let effect = self.reducer(&self.game, action, self.environment) else {
                return
            }
            effect
                .receive(on: DispatchQueue.main)
                .subscribe(on: queue)
                .sink(receiveValue: self.send)
                .store(in: &self.cancellables)
        }
    }
    
    func send2(_ action: ChessAction) {
        DispatchQueue.main.async {
            guard let effect = self.reducer(&self.game, action, self.environment) else {
                return
            }
            effect
                .sink(receiveValue: self.send)
                .store(in: &self.cancellables)
        }
    }
    
    
    
}
