//
//  Move+Names.swift
//
//  Created by Douglas Pedley on 11/29/20.
//  
//  The move names are a developer nicety. They provide namespace access to
//  the 64 squares as a start and end with a FEN like notation.
//  for example:
//  var aMove = Chess.Move.white.e2.e4
//  var bMove = Chess.Move(side: .white, start: .e2, end: .e4)
//  var cMove = Chess.Move(side: Side.white,
//                        start: Position.from(rankAndFile: "e2"),
//                          end: Position.from(rankAndFile: "e4"))
//  These three are equivalent, the first one is enabled by the namespacing in this file.
//

import Foundation

public extension Chess.Move {
    static let black = Chess.MoveStartSide(side: .black)
    static let white = Chess.MoveStartSide(side: .white)
}

// swiftlint:disable identifier_name
public extension Chess {
    struct MoveStart {
        public let side: Chess.Side
        public let position: Chess.Position
    }
    struct MoveStartSide {
        public let side: Chess.Side
        public var O_O: Chess.Move { castleKingside }
        public var castleKingside: Chess.Move {
            switch side {
            case .black: return e8.g8
            case .white: return e1.g1
            }
        }
        public var O_O_O: Chess.Move { castleQueenside }
        public var castleQueenside: Chess.Move {
            switch side {
            case .black: return e8.c8
            case .white: return e1.c1
            }
        }
        public let a1: Chess.MoveStart
        public let a2: Chess.MoveStart
        public let a3: Chess.MoveStart
        public let a4: Chess.MoveStart
        public let a5: Chess.MoveStart
        public let a6: Chess.MoveStart
        public let a7: Chess.MoveStart
        public let a8: Chess.MoveStart
        public let b1: Chess.MoveStart
        public let b2: Chess.MoveStart
        public let b3: Chess.MoveStart
        public let b4: Chess.MoveStart
        public let b5: Chess.MoveStart
        public let b6: Chess.MoveStart
        public let b7: Chess.MoveStart
        public let b8: Chess.MoveStart
        public let c1: Chess.MoveStart
        public let c2: Chess.MoveStart
        public let c3: Chess.MoveStart
        public let c4: Chess.MoveStart
        public let c5: Chess.MoveStart
        public let c6: Chess.MoveStart
        public let c7: Chess.MoveStart
        public let c8: Chess.MoveStart
        public let d1: Chess.MoveStart
        public let d2: Chess.MoveStart
        public let d3: Chess.MoveStart
        public let d4: Chess.MoveStart
        public let d5: Chess.MoveStart
        public let d6: Chess.MoveStart
        public let d7: Chess.MoveStart
        public let d8: Chess.MoveStart
        public let e1: Chess.MoveStart
        public let e2: Chess.MoveStart
        public let e3: Chess.MoveStart
        public let e4: Chess.MoveStart
        public let e5: Chess.MoveStart
        public let e6: Chess.MoveStart
        public let e7: Chess.MoveStart
        public let e8: Chess.MoveStart
        public let f1: Chess.MoveStart
        public let f2: Chess.MoveStart
        public let f3: Chess.MoveStart
        public let f4: Chess.MoveStart
        public let f5: Chess.MoveStart
        public let f6: Chess.MoveStart
        public let f7: Chess.MoveStart
        public let f8: Chess.MoveStart
        public let g1: Chess.MoveStart
        public let g2: Chess.MoveStart
        public let g3: Chess.MoveStart
        public let g4: Chess.MoveStart
        public let g5: Chess.MoveStart
        public let g6: Chess.MoveStart
        public let g7: Chess.MoveStart
        public let g8: Chess.MoveStart
        public let h1: Chess.MoveStart
        public let h2: Chess.MoveStart
        public let h3: Chess.MoveStart
        public let h4: Chess.MoveStart
        public let h5: Chess.MoveStart
        public let h6: Chess.MoveStart
        public let h7: Chess.MoveStart
        public let h8: Chess.MoveStart

        // swiftlint:disable function_body_length
        public init(side: Chess.Side) {
            self.side = side
            self.a1 = .init(side: side, position: .a1)
            self.a2 = .init(side: side, position: .a2)
            self.a3 = .init(side: side, position: .a3)
            self.a4 = .init(side: side, position: .a4)
            self.a5 = .init(side: side, position: .a5)
            self.a6 = .init(side: side, position: .a6)
            self.a7 = .init(side: side, position: .a7)
            self.a8 = .init(side: side, position: .a8)
            self.b1 = .init(side: side, position: .b1)
            self.b2 = .init(side: side, position: .b2)
            self.b3 = .init(side: side, position: .b3)
            self.b4 = .init(side: side, position: .b4)
            self.b5 = .init(side: side, position: .b5)
            self.b6 = .init(side: side, position: .b6)
            self.b7 = .init(side: side, position: .b7)
            self.b8 = .init(side: side, position: .b8)
            self.c1 = .init(side: side, position: .c1)
            self.c2 = .init(side: side, position: .c2)
            self.c3 = .init(side: side, position: .c3)
            self.c4 = .init(side: side, position: .c4)
            self.c5 = .init(side: side, position: .c5)
            self.c6 = .init(side: side, position: .c6)
            self.c7 = .init(side: side, position: .c7)
            self.c8 = .init(side: side, position: .c8)
            self.d1 = .init(side: side, position: .d1)
            self.d2 = .init(side: side, position: .d2)
            self.d3 = .init(side: side, position: .d3)
            self.d4 = .init(side: side, position: .d4)
            self.d5 = .init(side: side, position: .d5)
            self.d6 = .init(side: side, position: .d6)
            self.d7 = .init(side: side, position: .d7)
            self.d8 = .init(side: side, position: .d8)
            self.e1 = .init(side: side, position: .e1)
            self.e2 = .init(side: side, position: .e2)
            self.e3 = .init(side: side, position: .e3)
            self.e4 = .init(side: side, position: .e4)
            self.e5 = .init(side: side, position: .e5)
            self.e6 = .init(side: side, position: .e6)
            self.e7 = .init(side: side, position: .e7)
            self.e8 = .init(side: side, position: .e8)
            self.f1 = .init(side: side, position: .f1)
            self.f2 = .init(side: side, position: .f2)
            self.f3 = .init(side: side, position: .f3)
            self.f4 = .init(side: side, position: .f4)
            self.f5 = .init(side: side, position: .f5)
            self.f6 = .init(side: side, position: .f6)
            self.f7 = .init(side: side, position: .f7)
            self.f8 = .init(side: side, position: .f8)
            self.g1 = .init(side: side, position: .g1)
            self.g2 = .init(side: side, position: .g2)
            self.g3 = .init(side: side, position: .g3)
            self.g4 = .init(side: side, position: .g4)
            self.g5 = .init(side: side, position: .g5)
            self.g6 = .init(side: side, position: .g6)
            self.g7 = .init(side: side, position: .g7)
            self.g8 = .init(side: side, position: .g8)
            self.h1 = .init(side: side, position: .h1)
            self.h2 = .init(side: side, position: .h2)
            self.h3 = .init(side: side, position: .h3)
            self.h4 = .init(side: side, position: .h4)
            self.h5 = .init(side: side, position: .h5)
            self.h6 = .init(side: side, position: .h6)
            self.h7 = .init(side: side, position: .h7)
            self.h8 = .init(side: side, position: .h8)
        }
        // swiftlint:enable function_body_length
    }
}

public extension Chess.MoveStart {
    var a1: Chess.Move { return .init(side: side, start: position, end: .a1) }
    var a2: Chess.Move { return .init(side: side, start: position, end: .a2) }
    var a3: Chess.Move { return .init(side: side, start: position, end: .a3) }
    var a4: Chess.Move { return .init(side: side, start: position, end: .a4) }
    var a5: Chess.Move { return .init(side: side, start: position, end: .a5) }
    var a6: Chess.Move { return .init(side: side, start: position, end: .a6) }
    var a7: Chess.Move { return .init(side: side, start: position, end: .a7) }
    var a8: Chess.Move { return .init(side: side, start: position, end: .a8) }
    var b1: Chess.Move { return .init(side: side, start: position, end: .b1) }
    var b2: Chess.Move { return .init(side: side, start: position, end: .b2) }
    var b3: Chess.Move { return .init(side: side, start: position, end: .b3) }
    var b4: Chess.Move { return .init(side: side, start: position, end: .b4) }
    var b5: Chess.Move { return .init(side: side, start: position, end: .b5) }
    var b6: Chess.Move { return .init(side: side, start: position, end: .b6) }
    var b7: Chess.Move { return .init(side: side, start: position, end: .b7) }
    var b8: Chess.Move { return .init(side: side, start: position, end: .b8) }
    var c1: Chess.Move { return .init(side: side, start: position, end: .c1) }
    var c2: Chess.Move { return .init(side: side, start: position, end: .c2) }
    var c3: Chess.Move { return .init(side: side, start: position, end: .c3) }
    var c4: Chess.Move { return .init(side: side, start: position, end: .c4) }
    var c5: Chess.Move { return .init(side: side, start: position, end: .c5) }
    var c6: Chess.Move { return .init(side: side, start: position, end: .c6) }
    var c7: Chess.Move { return .init(side: side, start: position, end: .c7) }
    var c8: Chess.Move { return .init(side: side, start: position, end: .c8) }
    var d1: Chess.Move { return .init(side: side, start: position, end: .d1) }
    var d2: Chess.Move { return .init(side: side, start: position, end: .d2) }
    var d3: Chess.Move { return .init(side: side, start: position, end: .d3) }
    var d4: Chess.Move { return .init(side: side, start: position, end: .d4) }
    var d5: Chess.Move { return .init(side: side, start: position, end: .d5) }
    var d6: Chess.Move { return .init(side: side, start: position, end: .d6) }
    var d7: Chess.Move { return .init(side: side, start: position, end: .d7) }
    var d8: Chess.Move { return .init(side: side, start: position, end: .d8) }
    var e1: Chess.Move { return .init(side: side, start: position, end: .e1) }
    var e2: Chess.Move { return .init(side: side, start: position, end: .e2) }
    var e3: Chess.Move { return .init(side: side, start: position, end: .e3) }
    var e4: Chess.Move { return .init(side: side, start: position, end: .e4) }
    var e5: Chess.Move { return .init(side: side, start: position, end: .e5) }
    var e6: Chess.Move { return .init(side: side, start: position, end: .e6) }
    var e7: Chess.Move { return .init(side: side, start: position, end: .e7) }
    var e8: Chess.Move { return .init(side: side, start: position, end: .e8) }
    var f1: Chess.Move { return .init(side: side, start: position, end: .f1) }
    var f2: Chess.Move { return .init(side: side, start: position, end: .f2) }
    var f3: Chess.Move { return .init(side: side, start: position, end: .f3) }
    var f4: Chess.Move { return .init(side: side, start: position, end: .f4) }
    var f5: Chess.Move { return .init(side: side, start: position, end: .f5) }
    var f6: Chess.Move { return .init(side: side, start: position, end: .f6) }
    var f7: Chess.Move { return .init(side: side, start: position, end: .f7) }
    var f8: Chess.Move { return .init(side: side, start: position, end: .f8) }
    var g1: Chess.Move { return .init(side: side, start: position, end: .g1) }
    var g2: Chess.Move { return .init(side: side, start: position, end: .g2) }
    var g3: Chess.Move { return .init(side: side, start: position, end: .g3) }
    var g4: Chess.Move { return .init(side: side, start: position, end: .g4) }
    var g5: Chess.Move { return .init(side: side, start: position, end: .g5) }
    var g6: Chess.Move { return .init(side: side, start: position, end: .g6) }
    var g7: Chess.Move { return .init(side: side, start: position, end: .g7) }
    var g8: Chess.Move { return .init(side: side, start: position, end: .g8) }
    var h1: Chess.Move { return .init(side: side, start: position, end: .h1) }
    var h2: Chess.Move { return .init(side: side, start: position, end: .h2) }
    var h3: Chess.Move { return .init(side: side, start: position, end: .h3) }
    var h4: Chess.Move { return .init(side: side, start: position, end: .h4) }
    var h5: Chess.Move { return .init(side: side, start: position, end: .h5) }
    var h6: Chess.Move { return .init(side: side, start: position, end: .h6) }
    var h7: Chess.Move { return .init(side: side, start: position, end: .h7) }
    var h8: Chess.Move { return .init(side: side, start: position, end: .h8) }
}
// swiftlint:enable identifier_name
