//
//  PlayerView.swift
//  Leela
//
//  Created by Douglas Pedley on 1/17/19.
//  Copyright © 2019 d0. All rights reserved.
//

import UIKit

class PlayerView: UIView {
    private var subviewLayoutComplete = false
    let nameLabel: UILabel
    let prisonerLabel: UILabel
    internal var nameWidth: NSLayoutConstraint?
    private static let nameWidthRatio: CGFloat = 3
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if !subviewLayoutComplete {
            addSubview(nameLabel)
            addSubview(prisonerLabel)
            
            nameWidth = nameLabel.widthAnchor.constraint(equalToConstant: frame.size.width / PlayerView.nameWidthRatio)
            NSLayoutConstraint.activate([
                nameWidth!, // Force cast is okay here, we created inline above.
                nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                nameLabel.topAnchor.constraint(equalTo: topAnchor),
                nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                prisonerLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
                prisonerLabel.topAnchor.constraint(equalTo: topAnchor),
                prisonerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                prisonerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)])
            subviewLayoutComplete = true
        } else {
            nameWidth?.constant = frame.width / PlayerView.nameWidthRatio
        }
    }
    
    public override init(frame: CGRect) {
        nameLabel = UILabel(frame: CGRect.zero)
        prisonerLabel = UILabel(frame: CGRect.zero)
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    func sharedInit() {
        translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        prisonerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = UIFont(name: "Courier", size: 20)
        nameLabel.backgroundColor = .lightGray
        nameLabel.textAlignment = .center
        nameLabel.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        nameLabel.layer.borderWidth = 2
        
        prisonerLabel.font = UIFont(name: "Courier", size: 20)
        prisonerLabel.backgroundColor = .lightGray
        nameLabel.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        prisonerLabel.layer.borderWidth = 2
    }
}
