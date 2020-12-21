//
//  Sound.swift
//
//  Created by Douglas Pedley on 1/21/19.
//

import AVFoundation

extension Chess {
    enum Sounds {
        private static func sound(url: URL?) -> AVAudioPlayer {
            guard let url = url,
                  let player = try? AVAudioPlayer(contentsOf: url) else {
                return AVAudioPlayer()
            }
            return player
        }
        private static let CaptureURL = Bundle.main.url(forResource: "Capture", withExtension: "mp3")
        private static let CheckURL = Bundle.main.url(forResource: "Check", withExtension: "mp3")
        private static let DefeatURL = Bundle.main.url(forResource: "Defeat", withExtension: "mp3")
        private static let MoveURL = Bundle.main.url(forResource: "Move", withExtension: "mp3")
        private static let VictoryURL = Bundle.main.url(forResource: "Victory", withExtension: "mp3")
        public static let Capture = sound(url: CaptureURL)
        public static let Check = sound(url: CheckURL)
        public static let Defeat = sound(url: DefeatURL)
        public static let Victory = sound(url: VictoryURL)
        public static let Move = sound(url: MoveURL)
    }
}
