//
//  Sound.swift
//
//  Created by Douglas Pedley on 1/21/19.
//

/// The sound is handled outside of this library, but for timing the optional
/// methods are included here.
public protocol ChessSoundEffectDelegate: class {
    func move()
    func capture()
    func check()
    func defeat()
    func victory()
}

public extension Chess {
    static var soundDelegate: ChessSoundEffectDelegate?
    class Sounds: ChessSoundEffectDelegate {
        public func move() {
            Chess.soundDelegate?.move()
        }
        public func capture() {
            Chess.soundDelegate?.capture()
        }
        public func check() {
            Chess.soundDelegate?.check()
        }
        public func defeat() {
            Chess.soundDelegate?.defeat()
        }
        public func victory() {
            Chess.soundDelegate?.victory()
        }
        public init() {}
    }
}
