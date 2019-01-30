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
    static let highlightColor = UIColor.yellow.withAlphaComponent(selectionAlpha)
    static let premoveColor = UIColor.blue.withAlphaComponent(selectionAlpha)
    static let attention = UIColor.red.withAlphaComponent(selectionAlpha)

    var position: Chess.Position?
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    private var tapRecognizer: UITapGestureRecognizer?
    private var isTargetViewSetup = false
    private let targetView = UIView(frame: CGRect.zero)
    private var selectionType: Chess.UI.Selection = .none {
        didSet {
            updateSelectionUI()
        }
    }
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

extension SquareView {
    // Selection related stuff
    private func setupTargetView() {
        if isTargetViewSetup { return }
        guard !frame.equalTo(CGRect.zero) else {
            fatalError("Developer error, cannot call setupTargetView before frame is ready.")
        }
        isTargetViewSetup = true
        addSubview(targetView)
        NSLayoutConstraint.activate(targetView.fullFrameConstraints(targetView))
        targetView.layer.cornerRadius = frame.size.width / 2
        targetView.backgroundColor = .cyan
    }
    
    private func updateSelectionUI() {
        guard Thread.isMainThread else {
            weak var weakSelf = self
            DispatchQueue.main.async {
                if let strongSelf = weakSelf {
                    strongSelf.updateSelectionUI()
                }
            }
            return
        }
        switch selectionType {
        case .none:
            backgroundColor = .clear
            targetView.alpha = 0
        case .highlight:
            backgroundColor = SquareView.highlightColor
            targetView.alpha = 0
        case .target:
            setupTargetView()
            backgroundColor = .clear
            targetView.alpha = SquareView.selectionAlpha
        case .premove:
            backgroundColor = SquareView.premoveColor
            targetView.alpha = 0
        case .attention:
            backgroundColor = SquareView.attention
            targetView.alpha = 0
        }
    }
    
    func setSelected(_ newSelectionType: Chess.UI.Selection) {
        selectionType = newSelectionType
    }
    
    func clear(if outdatedSelectionType: Chess.UI.Selection) {
        if selectionType == outdatedSelectionType {
            selectionType = .none
        }
    }
}
