//
//  DetailViewController.swift
//  Chess Board
//
//  Created by Douglas Pedley on 8/2/19.
//  Copyright © 2019 Douglas Pedley. All rights reserved.
//

import UIKit
import SwiftUI

class BoardViewController: UIViewController {

    var board = ChessBoardView()
    lazy var hostingVC = UIHostingController(rootView: self.board)

    func configureView() {
        // Update the user interface for the detail item.
        if let source = source {
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addChild(hostingVC)
        self.view.addSubview(hostingVC.view)
        configureView()
    }

    var source: GameSource? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

