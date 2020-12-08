//
//  Game+Notation.swift
//
//  Created by Douglas Pedley on 1/18/19.
//  Copyright © 2019 d0. All rights reserved.
//

/*
[Event "F/S Return Match"]
[Site "Belgrade, Serbia JUG"]
[Date "1992.11.04"]
[Round "29"]
[White "Fischer, Robert J."]
[Black "Spassky, Boris V."]
[Result "1/2-1/2"]

1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 {This opening is called the Ruy Lopez.}
4. Ba4 Nf6 5. O-O Be7 6. Re1 b5 7. Bb3 d6 8. c3 O-O 9. h3 Nb8 10. d4 Nbd7
11. c4 c6 12. cxb5 axb5 13. Nc3 Bb7 14. Bg5 b4 15. Nb1 h6 16. Bh4 c5 17. dxe5
Nxe4 18. Bxe7 Qxe7 19. exd6 Qf6 20. Nbd2 Nxd6 21. Nc4 Nxc4 22. Bxc4 Nb6
23. Ne5 Rae8 24. Bxf7+ Rxf7 25. Nxf7 Rxe1+ 26. Qxe1 Kxf7 27. Qe3 Qg5 28. Qxg5
hxg5 29. b3 Ke6 30. a3 Kd6 31. axb4 cxb4 32. Ra5 Nd5 33. f3 Bc8 34. Kf2 Bf5
35. Ra7 g6 36. Ra6+ Kc5 37. Ke1 Nf4 38. g3 Nxh3 39. Kd2 Kb5 40. Rd6 Kc5 41. Ra6
Nf2 42. g4 Bd3 43. Re6 1/2-1/2
*/

import Foundation

extension Chess.Game {
    public enum PGNResult: String {
        case blackWon = "0-1"
        case whiteWon = "1-0"
        case draw = "1/2-1/2"
        case other = "*"
    }
    public struct AnnotatedMove {
        var side: Chess.Side
        var move: String
        var fenAfterMove: String
        var annotation: String?
    }
    public struct PortableNotation { // PGN
        var eventName: String // the name of the tournament or match event.
        var site: String      // the location of the event. This is in City, Region COUNTRY format,
                              // where COUNTRY is the three-letter International Olympic Committee code
                              // for the country. An example is New York City, NY USA.
        var date: Date        // the starting date of the game, in YYYY.MM.DD form. ?? is used for unknown values.
        var round: Int        // the playing round ordinal of the game within the event.
        var black: String     // the player of the black pieces, in Lastname, Firstname format.
        var white: String     // the player of the white pieces, same format as black.
        var result: PGNResult // the result of the game. This can only have four possible values:
                              // 1-0 (White won), 0-1 (Black won), 1/2-1/2 (Draw),
                              // or * (other, e.g., the game is ongoing).
        var tags: [String: String] = [:]
        var moves: [AnnotatedMove]
        var formattedString: String {
            var PGN = "[Event \"\(eventName)\"]\n" +
                "[Site \"\(site)\"]\n[Date \"\(date)\"]\n[Round \"\(round)\"]\n" +
                "[White \"\(white)\"]\n[Black \"\(black)\"]\n[Result \"\(result.rawValue)\"]\n"
            for (key, value) in tags {
                PGN.append("[\(key) \"\(value)\"]\n")
            }
            var numberPrefix = 1
            var lineLength = 0
            for move in moves {
                // We haven't finished annotations yet.
                let movePrefix: String
                if move.side == .white {
                    movePrefix = "\(numberPrefix). "
                    numberPrefix += 1
                } else {
                    movePrefix = ""
                }
                let moveString = "\(movePrefix)\(move)"
                if lineLength == 0 {
                    PGN.append(moveString)
                    lineLength = moveString.count
                } else if (lineLength + moveString.count) > 80 {
                    PGN.append("\n\(moveString)")
                    lineLength = moveString.count
                } else {
                    PGN.append(" \(moveString)")
                    lineLength += moveString.count
                }
            }
            PGN.append(" \(result.rawValue)")
            return PGN
        }
        // When creating game PGNs we note the device info for elo stats.
        // No personal information is tapped here, the string created is in the format "iPhone10,1"
        // See https://stackoverflow.com/questions/11197509/how-to-get-device-make-and-model-on-ios
        internal static func deviceSite() -> String {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            return identifier
        }
    }
    static func sampleGame() -> Chess.Game {
        let fischer = Chess.Robot.PlaybackBot(firstName: "Robert J.", lastName: "Fischer", side: .white, moveStrings: [
                                                "e2e4", "g1f3", "f1b5", "b5a4", "O-O", "f1e1", "a4b3", "c2c3", "h2h3",
                                                "d2d4", "c3c4", "c4b5", "b1c3", "c1g5", "c3b1", "g5h4", "d4e5", "h4e7",
                                                "e5d6", "b1d2", "d2c4", "b3c4", "f3e5", "c4f7", "e5f7", "d1e1", "e1e3",
                                                "e3g5", "b2b3", "a2a3", "a3b4", "a1a5", "f2f3", "g1f2", "a5a7", "a7a6",
                                                "f2e1", "g2g3", "e1d2", "a6d6", "d6a6", "g3g4", "a6e6"])
        let spassky = Chess.Robot.PlaybackBot(firstName: "Boris V.", lastName: "Spassky", side: .black, moveStrings: [
                                                "e7e5", "b8c6", "a7a6", "g8f6", "f8e7", "b7b5", "d7d6", "O-O", "c6b8",
                                                "b8d7", "c7c6", "a6b5", "c8b7", "b5b4", "h7h6", "c6c5", "f6e4", "d8e7",
                                                "e7f6", "e4d6", "d6c4", "d7b6", "a8e8", "f8f7", "e8e1", "g8f7", "f6g5",
                                                "h6g5", "f7e6", "e6d6", "c5b4", "b6d5", "b7c8", "c8f5", "g7g6", "d6c5",
                                                "d5f4", "f4h3", "c5b5", "b5c5", "h3f2", "f5d3"])
        fischer.responseDelay = 0.05
        spassky.responseDelay = 0.05
        return Chess.Game(fischer, against: spassky)
    }
}
