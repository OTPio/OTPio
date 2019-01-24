//
//  ThemeDisplayFSPVC.swift
//  otpio
//
//  Created by Mason Phillips on 12/3/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import FSPagerView
import libtoken

class ThemeDisplayFSPCV: FSPagerViewCell {
    
    let themeNameLabel: SystemLabel = SystemLabel(.center, size: 20)
    let sample: CodeTableViewCell = CodeTableViewCell(frame: CGRect())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sample.cellType = .expanded
        
        let testUrl = URL(string: fetchString(forKey: "test-token"))!
        let testToken = Token(from: testUrl)!
        sample.configure(with: testToken)
        
        addSubview(themeNameLabel)
        addSubview(sample)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        themeNameLabel.anchorAndFillEdge(.top, xPad: 15, yPad: 20, otherSize: 22)
        sample.anchorInCenter(width: self.width * 0.8, height: 120)
        sample.isUserInteractionEnabled = false
    }
    
    func theme(with t: Theme) {
        let c = t.colorsForTheme()
        themeNameLabel.textColor = c[.emphasizedText]
        sample.theme(t)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
