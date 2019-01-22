//
//  BaseUILabel.swift
//  otpio
//
//  Created by Mason Phillips on 1/21/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit

class BaseUIL: UILabel {
    
    var isEmphasized: Bool = false
    var isSecondary : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseUIL.theme(with:)), name: .themeDidChange, object: ThemeEngine.self)
        
        theme(with: ThemeEngine.sharedInstance.currentTheme)
    }
    
    @objc func theme(with t: Any) {
        guard let theme = t as? Theme else {
            fatalError("Could not cast back to theme")
        }
        
        let colors = theme.colorsForTheme()
        if isEmphasized { textColor = colors.emphasizedText }
        else if isSecondary { textColor = colors.secondaryText }
        else { textColor = colors.normalText }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
