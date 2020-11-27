//
//  Position.swift
//
//  Created by Douglas Pedley on 1/5/19.
//  Copyright © 2019 d0. All rights reserved.
//

import Foundation

public protocol Chess_PositionStoring {
    var fileNumber: Int { get }
    var rank: Int { get }
    var rawIndex: Int { get set }
}

extension Chess {
    public typealias Position = Int
    
}

extension Chess.Position: Chess_PositionStoring {
    // The number's aren't meaningful, just negative and unique
    private static let timeoutPositionInt = -4
    private static let resignPositionInt = -17
    private static let pausedPositionInt = -1971
    // Note: fileNumber is a 0 based index into the file charaters
    //       rank is 1 based to reflect position
    private static let validRanks: [Int] = [1, 2, 3, 4, 5, 6, 7, 8]
    private static let validFiles: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    
    private static let isNotBoardPositionError = "Tried to access a position internals when it wasn't a board position"
    private static let fileCharacters: [Character] = [ "a", "b", "c", "d", "e", "f", "g", "h" ]
    private static let rankCharacters: [Character] = [ "0", "1", "2", "3", "4", "5", "6", "7", "8" ]

    static func from(fileNumber: Int, rank: Int) -> Chess.Position {
        return ((8 - rank) * 8) + fileNumber
    }
    
    public var rawIndex: Int { get { return self } set { self = newValue } }
    public var fileNumber: Int {
        return self % 8
    }
    
    public var rank: Int {
        return ((63 - self) / 8) + 1 // The +1 is because we are 1 based.
    }
    
    var file: Character {
        guard isBoardPosition else { fatalError(Chess.Position.isNotBoardPositionError) }
        return Chess.Position.fileCharacters[fileNumber]
    }
    
    var isResign: Bool {
        return self == Chess.Position.resignPositionInt
    }
    
    var isPaused: Bool {
        return self == Chess.Position.pausedPositionInt
    }
    
    var isTimeout: Bool {
        return self == Chess.Position.timeoutPositionInt
    }
    
    var isBoardPosition: Bool {
        return (self >= 0) && (self <= 63)
    }
    
    var FEN: String {
        return "\(file)\(rank)"
    }
    
    static func from(FENIndex: Int) -> Chess.Position {
        return FENIndex
    }
    
    static func from(rankAndFile: String) -> Chess.Position {
        guard rankAndFile.count==2,
            let fileCharaterIndex = Chess.Position.fileCharacters.firstIndex(of: rankAndFile.first ?? "X"),
            let rankNumber = Chess.Position.rankCharacters.firstIndex(of: rankAndFile.last ?? "X") else {
                fatalError("invalid rank and file string: \(rankAndFile)")
        }
        return self.from(fileNumber: fileCharaterIndex, rank: rankNumber)
    }
    
    func rankDistance(from otherPosition: Chess.Position) -> Int {
        guard isBoardPosition else { fatalError(Chess.Position.isNotBoardPositionError) }
        return abs(fileNumber - otherPosition.fileNumber)
    }
    
    func fileDistance(from otherPosition: Chess.Position) -> Int {
        guard isBoardPosition else { fatalError(Chess.Position.isNotBoardPositionError) }
        return abs(rank - otherPosition.rank)
    }
    
    func adjacentPosition(rankOffset: Int, fileOffset: Int) -> Chess.Position {
        guard isBoardPosition else { fatalError(Chess.Position.isNotBoardPositionError) }
        return Chess.Position.from(fileNumber: fileNumber + fileOffset, rank: rank + rankOffset)
    }
    
    static var resignedPosition: Chess.Position {
        return Chess.Position.resignPositionInt
    }
    
    static var pausedPosition: Chess.Position {
        return Chess.Position.pausedPositionInt
    }
    
    static var timedOutPosition: Chess.Position {
        return Chess.Position.timeoutPositionInt
    }
}
