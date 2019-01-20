//
//  TurnView.swift
//  Leela
//
//  Created by Douglas Pedley on 1/15/19.
//  Copyright © 2019 d0. All rights reserved.
//

import UIKit

public class TurnView: UIView {
    private var subviewLayoutComplete = false
    let numberLabel: UILabel
    let blackLabel: UILabel
    let whiteLabel: UILabel
    internal var numberLabelWidth: NSLayoutConstraint?
    private static let numberLabelWidthRatio: CGFloat = 10
    
    override public func layoutSubviews() {
        if !subviewLayoutComplete {
            addSubview(numberLabel)
            addSubview(blackLabel)
            addSubview(whiteLabel)

            numberLabelWidth = numberLabel.widthAnchor.constraint(equalToConstant: frame.size.width / TurnView.numberLabelWidthRatio)
            let halfTheRemainingWidth = ( frame.size.width - ( frame.size.width / TurnView.numberLabelWidthRatio ) ) / 2

            NSLayoutConstraint.activate([
                numberLabelWidth!, // Force cast is okay here, we created inline above.
                numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                numberLabel.topAnchor.constraint(equalTo: topAnchor),
                numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

                whiteLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor),
                whiteLabel.topAnchor.constraint(equalTo: topAnchor),
                whiteLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                whiteLabel.widthAnchor.constraint(equalToConstant: halfTheRemainingWidth),
                
                blackLabel.leadingAnchor.constraint(equalTo: whiteLabel.trailingAnchor),
                blackLabel.topAnchor.constraint(equalTo: topAnchor),
                blackLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                blackLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                blackLabel.widthAnchor.constraint(equalToConstant: halfTheRemainingWidth)])
            subviewLayoutComplete = true
        } else {
            numberLabelWidth?.constant = frame.width / TurnView.numberLabelWidthRatio
        }
    }
    
    public override init(frame: CGRect) {
        numberLabel = UILabel(frame: CGRect.zero)
        blackLabel = UILabel(frame: CGRect.zero)
        whiteLabel = UILabel(frame: CGRect.zero)
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not yet implemented")
    }

    func sharedInit() {
        translatesAutoresizingMaskIntoConstraints = false
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        blackLabel.translatesAutoresizingMaskIntoConstraints = false
        whiteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        numberLabel.font = UIFont(name: "Courier", size: 18)
        whiteLabel.adjustsFontSizeToFitWidth = true
        numberLabel.backgroundColor = .gray
        numberLabel.textAlignment = .center
        numberLabel.applyTheme()
        
        blackLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 28)
        whiteLabel.adjustsFontSizeToFitWidth = true
        blackLabel.backgroundColor = .lightGray
        blackLabel.applyTheme()
        
        whiteLabel.font = UIFont(name: "TimesNewRomanPSMT", size: 28)
        whiteLabel.adjustsFontSizeToFitWidth = true
        whiteLabel.backgroundColor = .lightGray
        whiteLabel.applyTheme()
    }
}
