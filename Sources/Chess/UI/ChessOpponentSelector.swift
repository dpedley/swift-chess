//
//  ChessOpponentSelector.swift
//  
//
//  Created by Douglas Pedley on 12/16/20.
//

import Foundation
import SwiftUI

public struct ChessOpponentSelector: View {
    @EnvironmentObject public var store: ChessStore
    enum Bot {
        case random
        case greedy
        case cautious
    }
    let black: Chess.Player
    let white: Chess.Player
    let sides: [Chess.Side]
    func blackButton() -> some View {
        if sides.contains(.black) {
            let color: Color
            if black.menuName() == store.game.black.menuName() {
                color = .blue
            } else {
                color = .gray
            }
            let button = Button(action: {}, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                    Text("Black")
                        .foregroundColor(.white)
                }
            }).frame(width: 70, alignment: .center)
            return AnyView(button)
        }
        return AnyView(EmptyView())
    }
    func whiteButton() -> some View {
        if sides.contains(.white) {
            let color: Color
            if white.menuName() == store.game.white.menuName() {
                color = .blue
            } else {
                color = .gray
            }
            return AnyView(Button(action: {}, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                    Text("White")
                        .foregroundColor(.white)
                }
            }))
        }
        return AnyView(EmptyView())
    }
    public var body: some View {
        HStack {
            PlayerTitleView(player: black)
            Spacer()
            whiteButton()
            blackButton()
        }
    }
    init(_ playingAs: PlayAsButton.Choice, bot: Bot) {
        switch bot {
        case .random:
            black = Chess.Robot(side: .black)
            white = Chess.Robot(side: .white)
        case .greedy:
            black = Chess.Robot.GreedyBot(side: .black)
            white = Chess.Robot.GreedyBot(side: .white)
        case .cautious:
            black = Chess.Robot.CautiousBot(side: .black)
            white = Chess.Robot.CautiousBot(side: .white)
        }
        switch playingAs {
        case .black:
            sides = [.white]
        case .white:
            sides = [.black]
        case .watch:
            sides = [.white, .black]
        }
    }
}
