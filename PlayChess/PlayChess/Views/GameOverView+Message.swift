//
//  GameOverView+Message.swift
//  PlayChess
//
//  Created by Douglas Pedley on 1/6/21.
//

import SwiftUI
import Chess

extension GameOverView {
    struct Message: View {
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
}
