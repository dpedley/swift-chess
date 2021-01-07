//
//  RobotPlacard.swift
//  PlayChess
//
//  Created by Douglas Pedley on 1/6/21.
//

import SwiftUI
import Chess

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
