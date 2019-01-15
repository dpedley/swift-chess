//
//  Button.swift
//  Leela
//
//  Created by Douglas Pedley on 1/14/19.
//  Copyright © 2019 d0. All rights reserved.
//

import UIKit

class Button: UIView {

    func sharedInit() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
