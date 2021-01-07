//
//  RobotStories.swift
//  PlayChess
//
//  Created by Douglas Pedley on 1/6/21.
//

import Foundation

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
