//
//  BoardView.swift
//  Leela
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import UIKit
import QuartzCore

extension UIView {
    func fullFrameConstraints(_ toView: UIView) -> [NSLayoutConstraint] {
        return [
            self.topAnchor.constraint(equalTo: toView.topAnchor),
            self.bottomAnchor.constraint(equalTo: toView.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: toView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: toView.trailingAnchor) ]
    }    
}



class BoardView: UIView {
    private var subviewLayoutComplete = false
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

    override func layoutSubviews() {
        super.layoutSubviews()

        if subviewLayoutComplete { // We've previously done the layout setup below, here we just update our constants
            let oneEighthSize = CGSize(width: frame.size.width / 8, height: frame.size.height / 8)
            for index in 0...63 {
                let indexSquare = squares[index]
                let newOrigin = indexSquare.calculateOrigin(for: oneEighthSize)
                indexSquare.topConstraint?.constant = newOrigin.y
                indexSquare.leadingConstraint?.constant = newOrigin.x
            }
            
        } else { // This is where the square are wired up.
            
            boardImageView.translatesAutoresizingMaskIntoConstraints = false
            boardImageView.applyTheme()
            boardImageView.layer.masksToBounds = true // Imageview's will not respoect the corner radius without this
            boardImageView.layer.shouldRasterize = true // Mask to bounds is expensive without this.

            addSubview(boardImageView)
            NSLayoutConstraint.activate(boardImageView.fullFrameConstraints(self))
            let oneEighthSize = CGSize(width: frame.size.width / 8, height: frame.size.height / 8)
            for index in 0...63 {
                let indexSquare = squares[index]
                indexSquare.translatesAutoresizingMaskIntoConstraints = false
                addSubview(indexSquare)
                NSLayoutConstraint.activate(indexSquare.squareConstraints(self, originOffset: indexSquare.calculateOrigin(for: oneEighthSize)))
            }
            subviewLayoutComplete = true
        }
        
        sendSubviewToBack(boardImageView)
        super.layoutSubviews()
    }
    
    func clearAllSelections() {
        for square in squares {
            square.setSelected(.none)
        }
    }
    
    func setSquares(actionHandler: Chess_UISquareActionHandling) {
        for index in 0...63 {
            squares[index].actionHandler = actionHandler
        }
    }
}
