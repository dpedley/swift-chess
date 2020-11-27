//
//  File.swift
//  
//
//  Created by Douglas Pedley on 11/26/20.
//

import Foundation
import Combine

final class ChessStore: ObservableObject {
    @Published private(set) var state: ChessState

    private let environment: ChessEnvironment
    private let reducer: ChessStateReducer<ChessState, ChessAction, ChessEnvironment>
    private var cancellables: Set<AnyCancellable> = []

    init(
        initialState: ChessState,
        reducer: @escaping ChessStateReducer<ChessState, ChessAction, ChessEnvironment>,
        environment: ChessEnvironment
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    func send(_ action: ChessAction) {
        guard let effect = reducer(&state, action, environment) else {
            return
        }

        effect
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }
}
