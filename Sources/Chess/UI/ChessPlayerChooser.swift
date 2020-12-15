//
//  ChessPlayerChooser.swift
//  
//
//  Created by Douglas Pedley on 12/14/20.
//

import Foundation
import SwiftUI

public struct ChessPlayerChooser: View {
    @Binding var presentingChooser: Bool
    let side: Chess.Side
    var human: Chess.Player {
        Chess.HumanPlayer(side: side)
    }
    var randomBot: Chess.Player {
        Chess.Robot(side: side)
    }
    var greedyBot: Chess.Player {
        Chess.Robot.GreedyBot(side: side)
    }
    var cautiousBot: Chess.Player {
        Chess.Robot.CautiousBot(side: side)
    }
    @EnvironmentObject public var store: ChessStore
    public var body: some View {
        VStack(alignment: .leading, spacing: nil) {
            Button {
                setPlayer(Chess.HumanPlayer(side: side))
            } label: {
                HStack {
                    Image(systemName: human.iconName())
                    Text(human.menuName())
                }
            }
            Button {
                setPlayer(Chess.Robot(side: side))
            } label: {
                HStack {
                    Image(systemName: randomBot.iconName())
                    Text(randomBot.menuName())
                }
            }
            Button {
                setPlayer(Chess.Robot.GreedyBot(side: side))
            } label: {
                HStack {
                    Image(systemName: greedyBot.iconName())
                    Text(greedyBot.menuName())
                }
            }
            Button {
                setPlayer(Chess.Robot.CautiousBot(side: side))
            } label: {
                HStack {
                    Image(systemName: cautiousBot.iconName())
                    Text(cautiousBot.menuName())
                }
            }
        }
    }
    func setPlayer(_ player: Chess.Player) {
        switch side {
        case .black:
            store.game.black = player
        case .white:
            store.game.white = player
        }
        presentingChooser = false
    }
    public init(_ presentingChooser: Binding<Bool>, side: Chess.Side) {
        self.side = side
        self._presentingChooser = presentingChooser
    }
}

struct ChessPlayerChooserPreviews: PreviewProvider {
    @State static var presenting: Bool = true
    static var previews: some View {
        ChessPlayerChooser($presenting, side: .black)
    }
}
