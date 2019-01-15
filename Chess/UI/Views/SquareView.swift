//
//  SquareView.swift
//  Leela
//
//  Created by Douglas Pedley on 1/12/19.
//  Copyright © 2019 d0. All rights reserved.
//

import UIKit

class SquareView: UIImageView, Chess_UISquareVisualizer {
    static var pieceSet = Chess.UI.activeTheme.boardTheme.pieceSet
    var position: Chess.Position?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func calculateOrigin(for size: CGSize) -> CGPoint {
        return CGPoint(x: size.width * CGFloat(position?.fileNumber ?? 0) ,
                       y: size.height * CGFloat(8 - (position?.rank  ?? 1)))
    }
    
    func setSelected(_ selectionType: Chess.UI.Selection) {
        switch selectionType {
        case .none:
            backgroundColor = .clear
        case .selected:
            backgroundColor = .red
        case .target:
            backgroundColor = .blue
        }
    }
    
    func setOccupant(_ piece: Chess.UI.Piece) {
        guard Thread.isMainThread else {
            weak var weakSelf = self
            DispatchQueue.main.async {
                if let strongSelf = weakSelf {
                    strongSelf.setOccupant(piece)
                }
            }
            return
        }
        self.image = SquareView.pieceSet[piece]
    }
}
