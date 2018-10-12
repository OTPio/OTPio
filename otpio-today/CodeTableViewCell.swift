//
//  CodeTableViewCell.swift
//  otpio-today
//
//  Created by Mason Phillips on 10/12/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import OneTimePassword
import Neon

class CodeTableViewCell: UITableViewCell {

    var token: Token?
    
    let provider: UILabel
    let user    : UILabel
    let code    : UILabel
    let left    : UILabel
    
    var tokenTimer: Timer!

    var shouldShowCopied: Bool = false
    var copiedCount: Int = 5
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        provider = UILabel()
        provider.font = .systemFont(ofSize: 16)
        provider.textColor = .white
        
        user = UILabel()
        user.font = .systemFont(ofSize: 12)
        user.textColor = .white
        
        code = UILabel()
        code.font = UIFont(name: "SourceCodePro-ExtraLight", size: 22)
        code.textColor = .white
        code.textAlignment = .right
        
        left = UILabel()
        left.font = .systemFont(ofSize: 22)
        left.textColor = .white
        left.textAlignment = .right
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(provider)
        addSubview(user)
        addSubview(code)
        addSubview(left)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(with t: Token) {
        token = t
        
        provider.text = t.issuer
        user.text = t.name
        updateCode()
        startTimer()
    }
    
    override func layoutSubviews() {
        provider.anchorInCorner(.topLeft, xPad: 15, yPad: 5, width: width * 0.5, height: 18)
        user.align(.underCentered, relativeTo: provider, padding: 5, width: provider.width, height: 14)
        
        left.anchorAndFillEdge(.right, xPad: 5, yPad: 0, otherSize: 40)
        code.alignAndFillHeight(align: .toTheLeftCentered, relativeTo: left, padding: 5, width: width * 0.48)
    }
    
    func updateCode() {
        guard var c = token?.currentPassword else {
            code.text = "Error"; return
        }
        
        c.insert(" ", at: c.index(c.startIndex, offsetBy: 3))
        code.updateText(with: c, duration: 0.5)
    }
    
    private func timeRemaining() -> Float {
        guard let t = token else { return 0.0 }
        switch t.generator.factor {
        case .timer(let time):
            let epoch = Date().timeIntervalSince1970
            let d = Int(time - epoch.truncatingRemainder(dividingBy: time))
            return Float(d)
        default: return 0.0
        }
    }
    
    func stopTimer() {
        guard tokenTimer != nil else { return }
        tokenTimer.invalidate()
    }
    
    func startTimer() {
        let t = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (_) in
            let r = Int(self.timeRemaining())
            
            self.left.text = "\(r)s"
            
            if self.shouldShowCopied {
                if self.copiedCount > 1 {
                    self.copiedCount -= 1
                    self.code.updateText(with: "Copied", duration: 0.3)
                } else {
                    self.shouldShowCopied = false
                    self.copiedCount = 5
                }
            } else {
                self.updateCode()
            }
        }
        
        tokenTimer = t
    }

}

extension UILabel {
    public func updateText(with s: String, duration: Double?) {
        if s == self.text { return } // Nothing to change
        self.fadeTransition(duration ?? 0.4)
        self.text = s
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
