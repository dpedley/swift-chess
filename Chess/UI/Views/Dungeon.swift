//
//  Dungeon.swift
//  Leela
//
//  Created by Douglas Pedley on 1/21/19.
//  Copyright © 2019 d0. All rights reserved.
//

import UIKit

class Dungeon: UICollectionView {
    var prisoners: [Chess.UI.Piece] = []
    
    func imprison(_ piece: Chess.UI.Piece) {
        defer {
            // Call reload data, make sure it's on the main thread
            if Thread.isMainThread {
                reloadData()
            } else {
                weak var weakSelf = self
                DispatchQueue.main.async {
                    if let strongSelf = weakSelf {
                        strongSelf.reloadData()
                    }
                }
            }
        }
        
        if prisoners.count == 0 {
            // It's the first element
            prisoners.append(piece)
        } else {
            if let index = prisoners.index(where: { $0.rawValue > piece.rawValue }) {
                // Insert it before the lower ranks.
                prisoners.insert(piece, at: index)
            } else {
                // It's the last element
                prisoners.append(piece)
            }
        }
        
    }
}
