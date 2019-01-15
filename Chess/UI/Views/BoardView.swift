//
//  BoardView.swift
//  Leela
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import UIKit


class BoardView: UIView {
    internal let boardImageView = UIImageView(frame: CGRect.zero)
    var boardTheme: Chess.UI.BoardTheme = Chess.UI.activeTheme.boardTheme {
        didSet {
            boardImageView.image = boardTheme.color.image
            boardImageView.setNeedsLayout()
            SquareView.pieceSet = boardTheme.pieceSet
        }
    }
    
    var squares: [SquareView] = {
        var newSquares: [SquareView] = []
        for index in 0...63 {
            let newSquare = SquareView(frame: CGRect.zero)
            newSquare.position = Chess.Position.from(FENIndex: index)
            newSquares.append(newSquare)
        }
        return newSquares
    }()
    var squareLayoutComplete = false

    override func layoutSubviews() {
        if !squareLayoutComplete {
            addSubview(boardImageView)
            for index in 0...63 {
                let indexSquare = squares[index]
                addSubview(indexSquare)
            }
            sendSubviewToBack(boardImageView)
            squareLayoutComplete = true
        }
        boardImageView.frame = bounds
        let squareSize = CGSize(width: frame.width / 8, height: frame.height / 8)
        for index in 0...63 {
            let indexSquare = squares[index]
            indexSquare.frame = CGRect(origin: indexSquare.calculateOrigin(for: squareSize),
                                         size: squareSize)
        }        
        super.layoutSubviews()
    }
}
