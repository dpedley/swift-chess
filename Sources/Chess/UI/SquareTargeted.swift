//
//  SquareTargeted.swift
//  
//
//  Created by Douglas Pedley on 12/16/20.
//

import SwiftUI

public struct SquareCorners: Shape {
    public func path(in rect: CGRect) -> Path {
        let cornerY = rect.size.height / 4
        let cornerX = rect.size.width / 4
        let corner0 = CGPoint(x: rect.minX, y: rect.minY)
        let corner1 = CGPoint(x: rect.minX, y: rect.maxY)
        let corner2 = CGPoint(x: rect.maxX, y: rect.minY)
        let corner3 = CGPoint(x: rect.maxX, y: rect.maxY)
        return Path { path in
            // First Corner
            path.move(to: corner0)
            path.addLine(to: corner0.offset(dx: cornerX))
            path.addLine(to: corner0.offset(dy: cornerY))
            path.addLine(to: corner0)
            // Second Corner
            path.move(to: corner1)
            path.addLine(to: corner1.offset(dx: cornerX))
            path.addLine(to: corner1.offset(dy: -cornerY))
            path.addLine(to: corner1)
            // Third Corner
            path.move(to: corner2)
            path.addLine(to: corner2.offset(dx: -cornerX))
            path.addLine(to: corner2.offset(dy: cornerY))
            path.addLine(to: corner2)
            // Fourth Corner
            path.move(to: corner3)
            path.addLine(to: corner3.offset(dx: -cornerX))
            path.addLine(to: corner3.offset(dy: -cornerY))
            path.addLine(to: corner3)
        }
    }
}

public struct SquareTargeted: View {
    @EnvironmentObject public var store: ChessStore
    let position: Chess.Position
    public var body: some View {
        guard store.environment.preferences.highlightChoices,
              store.game.board.squares[position].targetedBySelected else {
            return AnyView(EmptyView())
        }
        guard store.game.board.squares[position].isEmpty else {
            // When we target a square that has a piece in it
            // we add vingettes on the corners
            let corners = SquareCorners()
                            .fill(Self.chessChoiceHighlight)
            return AnyView(corners)
        }
        let selected = GeometryReader { geometry in
            Circle()
                .inset(by: geometry.size.width / 3)
                .fill(Self.chessChoiceHighlight)
        }
        return AnyView(selected)
    }
    static let chessChoiceHighlight = Color(.sRGB, red: 0.5, green: 0.3, blue: 0.3, opacity: 0.35)
    public init(_ idx: Int) {
        self.position = Chess.Position(idx)
    }
}

struct SquareTargetedPreview: PreviewProvider {
    static let targetStore: ChessStore = {
        let FEN = "r4r2/1pp4k/p3P2p/2Pp1p2/bP5Q/P3q3/1B1n4/K6R b - - 1 33"
        let black = Chess.HumanPlayer(side: .black)
        let white = Chess.HumanPlayer(side: .white)
        var game = Chess.Game(white, against: black)
        game.board.resetBoard(FEN: FEN)
        ChessStore.userTappedSquare(.e3, game: &game)
        let store = ChessStore(game: game)
        store.environment.theme.color = .blue
        return store
    }()
    static var previews: some View {
        BoardView()
            .environmentObject(targetStore)
    }
}
