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
            var color: BoardColor = .brown
            var pieceSet: PieceSet
        }
        
        struct ChessTheme {
            var boardTheme: BoardTheme
            
            static var defaultTheme: ChessTheme = {
                let boardTheme = BoardTheme(color: .brown, pieceSet: loadPieces(themeName: "cburnett"))
                return ChessTheme(boardTheme: boardTheme)
            }()
        }
        
        static var activeTheme = ChessTheme.defaultTheme
    }
}
