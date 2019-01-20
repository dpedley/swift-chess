//
//  ChessThemes.swift
//  Leela
//
//  Created by Douglas Pedley on 1/13/19.
//  Copyright © 2019 d0. All rights reserved.
//

import UIKit

extension SquareView {
    // TODO themes
}

extension UIView {
    func applyTheme() {
        layer.borderColor = Chess.UI.borderColor
        layer.borderWidth = Chess.UI.borderWidth
        layer.cornerRadius = 4
    }
}
