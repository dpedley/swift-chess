//
//  Ledger.swift
//  Leela
//
//  Created by Douglas Pedley on 1/17/19.
//  Copyright © 2019 d0. All rights reserved.
//

import UIKit

class LedgerHeaderView: UIView {
    private var subviewLayoutComplete = false
    let white: PlayerView
    let black: PlayerView
    override init(frame: CGRect) {
        let halfWidth = frame.size.width / 2
        white = PlayerView(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: halfWidth, height: frame.size.height) )
        black = PlayerView(frame: CGRect(x: frame.origin.x + halfWidth, y: frame.origin.y, width: halfWidth, height: frame.size.height) )
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let halfWidth = frame.size.width / 2
        if !subviewLayoutComplete {
            subviewLayoutComplete = true
        } else {
        }
    }
}
