//
//  Sound.swift
//
//  Created by Douglas Pedley on 1/21/19.
//  Copyright © 2019 d0. All rights reserved.
//

import AVFoundation
/*
 private var backgroundSound: Sound?
 private var dogSound: Sound?
 
 override func viewDidLoad() {
 super.viewDidLoad()
 switchSoundEnabled.isOn = Sound.enabled
 if let dogUrl = Bundle.main.url(forResource: "dog", withExtension: "wav") {
 dogSound = Sound(url: dogUrl)
 }*/

extension Chess {
    enum Sounds {
        private static func Sound(url: URL) -> AVAudioPlayer {
            return try! AVAudioPlayer(contentsOf: url)
        }
        private static let BerserkURL = Bundle.main.url(forResource: "Berserk", withExtension: "mp3")!
        private static let CaptureURL = Bundle.main.url(forResource: "Capture", withExtension: "mp3")!
        private static let CheckURL = Bundle.main.url(forResource: "Check", withExtension: "mp3")!
        private static let ConfirmationURL = Bundle.main.url(forResource: "Confirmation", withExtension: "mp3")!
        private static let DefeatURL = Bundle.main.url(forResource: "Defeat", withExtension: "mp3")!
        private static let MoveURL = Bundle.main.url(forResource: "Move", withExtension: "mp3")!
        private static let VictoryURL = Bundle.main.url(forResource: "Victory", withExtension: "mp3")!
        public static let Berserk = Sound(url: BerserkURL)
        public static let Capture = Sound(url: CaptureURL)
        public static let Check = Sound(url: CheckURL)
        public static let Confirmation = Sound(url: ConfirmationURL)
        public static let Defeat = Sound(url: DefeatURL)
        public static let Victory = Sound(url: VictoryURL)
        public static let Move = Sound(url: MoveURL)
//        Capture.mp3
//        Check.mp3
//        Confirmation.mp3
//        CountDown0.mp3
//        CountDown1.mp3
//        CountDown10.mp3
//        CountDown2.mp3
//        CountDown3.mp3
//        CountDown4.mp3
//        CountDown5.mp3
//        CountDown6.mp3
//        CountDown7.mp3
//        CountDown8.mp3
//        CountDown9.mp3
//        Defeat.mp3
//        Draw.mp3
//        Explosion.mp3
//        GenericNotify.mp3
//        LowTime.mp3
//        Move.mp3
//        NewChallenge.mp3
//        NewPM.mp3
//        SocialNotify.mp3
//        Tournament1st.mp3
//        Tournament2nd.mp3
//        Tournament3rd.mp3
//        TournamentOther.mp3
//        Victory.mp3

    }
}
