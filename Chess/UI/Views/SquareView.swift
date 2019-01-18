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
    static let selectionAlpha: CGFloat = 0.3
    static let selectedColor = UIColor.yellow.withAlphaComponent(selectionAlpha)
    static let preMoveColor = UIColor.blue.withAlphaComponent(selectionAlpha)
    
    var position: Chess.Position?
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    private var tapRecognizer: UITapGestureRecognizer?
    weak var actionHandler: Chess_UISquareActionHandling? {
        didSet {
            guard let _ = self.tapRecognizer else {
                let aTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
                aTapRecognizer.numberOfTapsRequired = 1
                self.addGestureRecognizer(aTapRecognizer)
                self.tapRecognizer = aTapRecognizer
                return
            }
        }
    }

    func sharedInit() {
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
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
            backgroundColor = SquareView.selectedColor
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

extension SquareView { // Actions
    @IBAction func tapped(_ sender: Any) {
        self.actionHandler?.tap(square: self)
    }
}


extension SquareView { // UIKit stuff
    func squareConstraints(_ toView: UIView, originOffset: CGPoint) -> [NSLayoutConstraint] {
        let topAnchorConstraint: NSLayoutConstraint
        let leadingAnchorConstraint: NSLayoutConstraint
        if let aConstraint = self.topConstraint {
            topAnchorConstraint = aConstraint
            topAnchorConstraint.constant = originOffset.y
        } else {
            topAnchorConstraint = self.topAnchor.constraint(equalTo: toView.topAnchor, constant: originOffset.y)
            self.topConstraint = topAnchorConstraint
        }
        
        if let bConstraint = self.leadingConstraint {
            leadingAnchorConstraint = bConstraint
            leadingAnchorConstraint.constant = originOffset.x
        } else {
            leadingAnchorConstraint = self.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: originOffset.x)
            self.leadingConstraint = leadingAnchorConstraint
        }
        return [
            self.widthAnchor.constraint(equalTo: toView.widthAnchor, multiplier: 0.125),
            self.heightAnchor.constraint(equalTo: toView.heightAnchor, multiplier: 0.125),
            topAnchorConstraint, leadingAnchorConstraint]
    }
}
