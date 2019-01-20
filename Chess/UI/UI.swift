//
//  UI.swift
//  phasestar
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import UIKit

// Some namespacing
extension Chess {
    public enum UI {
        enum BoardColor {
            case brown
            case blue
            case green
            case purple
            var image: UIImage {
                let colorName: String
                switch self {
                case .brown:
                    colorName = "brown"
                case .blue:
                    colorName = "blue"
                case .green:
                    colorName = "green"
                case .purple:
                    colorName = "purple"
                }
                guard let boardImage = UIImage(named: colorName) else {
                    fatalError("Cannot load \(colorName)")
                }
                return boardImage
            }
        }
        
        struct BoardTheme {
            var color: BoardColor = .blue
            var pieceSet: PieceSet
        }
        
        struct ChessTheme {
            var boardTheme: BoardTheme
            
            static var defaultTheme: ChessTheme = {
                let boardTheme = BoardTheme(color: .blue, pieceSet: loadPieces(themeName: "cburnett"))
                return ChessTheme(boardTheme: boardTheme)
            }()
        }
        
        static var activeTheme = ChessTheme.defaultTheme
    }
}

extension Chess.UI {
    static let playControlsColor = UIColor.white
    static let controlAttributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.foregroundColor: UIColor.black,
        NSAttributedString.Key.font: UIFont(name: "lichess", size: 24)!]
    public static let rewind = NSAttributedString(string: "W", attributes: controlAttributes)
    public static let previous = NSAttributedString(string: "Y", attributes: controlAttributes)
    public static let play = NSAttributedString(string: "G", attributes: controlAttributes)
    public static let next = NSAttributedString(string: "X", attributes: controlAttributes)
    public static let fastForward = NSAttributedString(string: "V", attributes: controlAttributes)
    
    public static let borderColor = UIColor.black.withAlphaComponent(0.8).cgColor
    public static let borderWidth: CGFloat = 2
}
