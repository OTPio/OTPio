//
//  UIKit.swift
//  otpio
//
//  Created by Mason Phillips on 10/10/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import libfa

class SystemLabel: UILabel {
    
    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    init(_ position: NSTextAlignment?, size: CGFloat?) {
        super.init(frame: CGRect())
        
        textColor = .flatWhite
        textAlignment = position ?? .left
        font = .systemFont(ofSize: size ?? UIFont.systemFontSize)
    }
    
    convenience init(withFA f: FontAwesomeStyle, textPosition t: NSTextAlignment?, size s: CGFloat?) {
        self.init(t, size: s)
        
        switch f {
        case .light  : font = FALIGHT_UIFONT
        case .regular: font = FAREGULAR_UIFONT
        case .solid  : font = FASOLID_UIFONT
        case .brands : font = FABRANDS_UIFONT
        }
    }

    convenience init() {
        self.init(nil)
    }
    
    convenience init(_ position: NSTextAlignment?) {
        self.init(position, size: nil)
    }
    
    public func updateText(with s: String, duration: Double?) {
        if s == self.text { return } // Nothing to change
        self.fadeTransition(duration ?? 0.4)
        self.text = s
    }
    
    public func multiline() {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
}

class SystemButton: UIButton {
    
    init(backgroundColor bg: UIColor?, text t: String) {
        super.init(frame: CGRect())
        
        titleLabel?.textColor = .flatWhite
        setTitle(t, for: .normal)
        backgroundColor = bg ?? .clear
    }
    
    convenience init(faType f: FontAwesomeStyle, backgroundColor bg: UIColor?, text t: String) {
        self.init(backgroundColor: bg, text: t)
        
        let font: UIFont
        switch f {
        case .light  : font = FALIGHT_UIFONT
        case .regular: font = FAREGULAR_UIFONT
        case .solid  : font = FASOLID_UIFONT
        case .brands : font = FABRANDS_UIFONT
        }
        
        titleLabel?.font = font
    }
    
    convenience init() {
        self.init(backgroundColor: nil, text: "")
    }
    
    func roundCorners() {
        layer.cornerRadius = 15
    }
    
    func fa(icon i: String) {
        self.setTitle("\(i)", for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class SystemViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class SystemView: UIView {
    init() {
        super.init(frame: CGRect())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func roundCorners() {
        layer.cornerRadius = 15
    }
}

// MARK: - Extensions

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
