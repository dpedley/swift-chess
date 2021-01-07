//
//  GameOverView.swift
//  PlayChess
//
//  Created by Douglas Pedley on 12/18/20.
//

import SwiftUI
import Chess

struct GameOverMessage: View {
    let title: String
    let titleFont = Font.system(size: 40)
    let message: String
    let messageFont = Font.system(size: 48).weight(.semibold)
    let result: String
    let resultFont = Font.system(size: 24).weight(.thin)
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(titleFont)
            Text(message)
                .font(messageFont)
                .foregroundColor(.secondary)
            Text(result)
                .font(resultFont)
        }
        .multilineTextAlignment(.center)
        .padding(24)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color.primary)
                RoundedRectangle(cornerRadius: 10.0)
                    .inset(by: 2)
                    .fill(Color(UIColor.systemBackground))
            }
        )
        .drawingGroup()
    }
    init(title: String, message: String, result: String) {
        self.title = title
        self.message = message
        self.result = result
    }
}

struct GameOverView: View {
    @EnvironmentObject var store: ChessStore
    @Binding var gameOverVisible: Chess.GameUpdate?
    @State private var startSpring = false
    var body: some View {
        guard let gameOverVisible = gameOverVisible else {
            return AnyView(EmptyView())
        }
        guard case .gameEnded(let result, let status) = gameOverVisible else {
            return AnyView(EmptyView())
        }
        let human = findHuman(game: store.game)
        guard let (title, message) = resultMessage(result, human: human) else {
            return AnyView(EmptyView())
        }
        let resultString: String
        if let ender = status.gameEnder {
            resultString = "by \(ender.lowercased())"
        } else {
            resultString = ""
        }
        return AnyView(GeometryReader { geometry in
            ZStack {
                GameOverMessage(title: title,
                                message: message.uppercased(),
                                result: resultString)
                    .scaleEffect(self.startSpring ? 1 : 0.1)
                    .animation(.interpolatingSpring(mass: 0.2,
                                                stiffness: 6,
                                                damping: 0.66,
                                                initialVelocity: 5))
                .onAppear {
                    self.startSpring = true
                }
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height,
                   alignment: .center)
            .background(Color.primary.opacity(0.5))
            .onTapGesture {
                self.gameOverVisible = nil
                self.startSpring = false
            }
        })
    }
    func findHuman(game: Chess.Game) -> Chess.HumanPlayer? {
        var human: Chess.HumanPlayer?
        if let player = game.black as? Chess.HumanPlayer {
            human = player
        } else if let player = game.white as? Chess.HumanPlayer {
            human = player
        }
        return human
    }
    func resultMessage(_ result: Chess.Game.PGNResult, human: Chess.HumanPlayer?) -> (String, String)? {
        let celebrate = "Well done!"
        let encourage = "Try again"
        let bot = "Game Over"
        let blackLabel: String
        let whiteLabel: String
        if store.game.black.menuName() == store.game.white.menuName() {
            blackLabel = human?.side == Chess.Side.black ? human!.menuName() : Chess.Side.black.description
            whiteLabel = human?.side == Chess.Side.white ? human!.menuName() : Chess.Side.white.description
        } else {
            blackLabel = human?.side == Chess.Side.black ? human!.menuName() : store.game.black.menuName()
            whiteLabel = human?.side == Chess.Side.white ? human!.menuName() : store.game.white.menuName()
        }
        switch result {
        case .other:
            return nil
        case .blackWon:
            guard let human = human else {
                return (bot, "\(blackLabel) wins")
            }
            let name = human.menuName()
            guard human.side == .black else {
                return (encourage, "\(name) lost")
            }
            return (celebrate, "\(name) won")
        case .whiteWon:
            guard let human = human else {
                return (bot, "\(whiteLabel) wins")
            }
            let name = human.menuName()
            guard human.side == .white else {
                return (encourage, "\(name) lost")
            }
            return (celebrate, "\(name) won")
        case .draw:
            guard human != nil else {
                return (bot, "Draw")
            }
            return (encourage, "Draw")
        }
    }
    init(_ info: Binding<Chess.GameUpdate?>) {
        self._gameOverVisible = info
    }
}

struct GameOverViewPreview: PreviewProvider {
    static var mate: ChessStore = {
        var white = Chess.HumanPlayer(side: .white)
        white.moveAttempt = Chess.Move.white.h4.h7
        let black = Chess.Robot.CautiousBot(side: .black)
        let game = Chess.Game(white, against: black)
        let store = ChessStore(game: game)
        store.game.userPaused = false
        store.game.board.resetBoard(FEN: "r1n2r2/5pkp/p1p2qp1/6N1/2nP3Q/5B2/PPP3PP/R4RK1 w - - 8 26")
        Chess.soundDelegate = nil
        store.gameAction(.startGame)
        return store
    }()
    @StateObject static var store: ChessStore = mate
    static var previews: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    BoardGameView()
                        .frame(height: geometry.size.width * 1.25)
                    HStack {
                        ChessLedgerView()
                            .frame(width: geometry.size.width / 2)
                        VStack(spacing: 0) {
                            DungeonView(side: .white)
                            DungeonView(side: .black)
                        }
                        .frame(width: geometry.size.width / 2)
                    }
                }
                GameOverView($store.game.info)
                    .frame(width: geometry.size.width,
                           height: geometry.size.height,
                           alignment: .center)
            }
            .environmentObject(mate)
        }
    }
}
