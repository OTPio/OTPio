//
//  BaseUILabel.swift
//  otpio
//
//  Created by Mason Phillips on 1/21/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit
import LibFA

class BaseUIL: UILabel {
    
    var isEmphasized: Bool = false
    var isSecondary : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseUIL.theme(with:)), name: .themeDidChange, object: ThemeEngine.self)
        
        theme(with: ThemeEngine.sharedInstance.currentTheme)
    }
    
    convenience init(_ align: NSTextAlignment = .left, size: CGFloat = UIFont.systemFontSize, faStyle: FontAwesomeStyle? = nil) {
        self.init(frame: .zero)
        
        textAlignment = align
        guard let style = faStyle else {
            self.font = UIFont.systemFont(ofSize: size)
            return
        }
        
        let font: FontConvertible
        switch style {
        case .regular: font = FontFamily.FontAwesome5Pro.regular
        case .light  : font = FontFamily.FontAwesome5Pro.light
        case .solid  : font = FontFamily.FontAwesome5Pro.solid
        case .brands : font = FontFamily.FontAwesome5Brands.regular
        }
        
        self.font = font.font(size: size)
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
