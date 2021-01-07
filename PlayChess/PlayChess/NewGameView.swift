//
//  NewGameView.swift
//  PlayChess
//
//  Created by Douglas Pedley on 1/2/21.
//

import Foundation
import Chess
import SwiftUI

enum RobotStories {
    static let randomBot = """
    The easiest challenger in your robot training group. This robot will move without
     thinking. It will pick any move that is allowed, even if it is a blunder. Try this
     robot out if you're still learning the game
    """.replacingOccurrences(of: "\n", with: "")
    static let greedyBot = """
    Attack and capture is the only thing this bot thinks about. Once you've learned how to
     move the pieces, you'll find it becomes easy to out think this robot. Make sure to
     protect your pieces, and GreedyBot will capture and blunder.
    """.replacingOccurrences(of: "\n", with: "")
    static let cautiousBot = """
    The last of the learning bots. CautiousBot focuses on avoiding risky moves, and trying
     to trade when it's favorable. When you can beat CautiousBot, you can feel comfortable
     that you get the basics of Chess.
    """.replacingOccurrences(of: "\n", with: "")
}

struct RobotPlacard: View {
    let robot: Chess.Robot
    func robotStory() -> some View {
        let robotStory: String
        switch robot.menuName() {
        case "GreedyBot":
            robotStory = RobotStories.greedyBot
        case "CautiousBot":
            robotStory = RobotStories.cautiousBot
        default: // aka case "RandomBot":
            robotStory = RobotStories.randomBot
        }
        return AnyView(
            Text("\(robotStory)")
                .lineLimit(7)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
        )
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PlayerTitleView(player: robot)
            robotStory()
        }
        .foregroundColor(.secondary)
        .padding()
    }
    init?(_ player: Chess.Player) {
        guard let robot = player as? Chess.Robot else {
            return nil
        }
        self.robot = robot
    }
}

struct NewGameView: View {
    @EnvironmentObject var store: ChessStore
    var startMessage: String {
        guard store.game.white is Chess.HumanPlayer else {
            return "Start the game with the play icon"
        }
        return "Make your first more to start the game"
    }
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                RobotPlacard(store.game.white)
                RobotPlacard(store.game.black)
            }
            Spacer()
            Text("\(startMessage),")
                .font(.footnote)
                .fontWeight(.ultraLight)
            Text("or change settings using the gear icon")
                .font(.footnote)
                .fontWeight(.ultraLight)
            Spacer()
        }
    }
}

struct NewGameViewPreview: PreviewProvider {
    static var store: ChessStore = {
        var white = Chess.HumanPlayer(side: .white)
        let black = Chess.Robot.CautiousBot(side: .black)
        let game = Chess.Game(white, against: black)
        let store = ChessStore(game: game)
        Chess.soundDelegate = nil
        return store
    }()
    static var previews: some View {
        ContentView().environmentObject(store)
    }
}
