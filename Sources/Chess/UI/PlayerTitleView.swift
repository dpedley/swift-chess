//
//  PlayerTitleView.swift
//  
//
//  Created by Douglas Pedley on 12/16/20.
//
import Foundation
import SwiftUI

public struct PlayerTitleView: View {
    let player: Chess.Player
    @State var thinking = false
    var foreverAnimation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    public var body: some View {
        HStack {
            Image(systemName: player.iconName())
                .rotationEffect(Angle(degrees: self.thinking ? 360 : 0.0))
                .animation(self.thinking ? foreverAnimation : .default)
            Text("\(player.menuName())")
        }
    }
    public init(player: Chess.Player) {
        self.player = player
    }
}

struct PlayerTitleViewPreviews: PreviewProvider {
    static let human: PlayerTitleView = {
        let player = Chess.HumanPlayer(side: .white)
        return PlayerTitleView(player: player)
    }()
    static let cautiousBot: PlayerTitleView = {
        let player = Chess.Robot.CautiousBot(side: .black)
        return PlayerTitleView(player: player)
    }()
    static let greedyBot: PlayerTitleView = {
        let player = Chess.Robot.GreedyBot(side: .white)
        var label = PlayerTitleView(player: player)
        return label
    }()
    static var previews: some View {
        VStack {
            human
            cautiousBot
            greedyBot
        }
        .onAppear {
            cautiousBot.thinking = true
        }
    }
}
