//
//  IconTVC.swift
//  otpio
//
//  Created by Mason Phillips on 12/3/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import Eureka
import libfa

class IconDisplayTVC: UITableViewCell {
    var iconLabel: SystemLabel?
    var nameLabel: SystemLabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        iconLabel = SystemLabel(withFA: .brands, textPosition: .left, size: 20)
        nameLabel = SystemLabel(.right, size: 16)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconLabel?.textColor = .flatBlack
        nameLabel?.textColor = .flatBlack
        
        addSubview(iconLabel!)
        addSubview(nameLabel!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconLabel?.anchorAndFillEdge(.left, xPad: 15, yPad: 5, otherSize: 30)
        nameLabel?.anchorAndFillEdge(.right, xPad: 15, yPad: 5, otherSize: nameLabel?.intrinsicContentSize.width ?? 150)
    }
}
