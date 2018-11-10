//
//  CodeTableViewCell.swift
//  otpio
//
//  Created by Mason Phillips on 10/11/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import OneTimePassword
import GradientProgressBar
import SwipeCellKit
import RetroProgress

class CodeTableViewCell: SwipeTableViewCell {

    let mainView: SystemView  = SystemView()
    
    let provider: SystemLabel = SystemLabel()
    let user    : SystemLabel = SystemLabel()
    let code    : SystemLabel = SystemLabel()
    let time    : SystemLabel = SystemLabel()
    
    let progress: ProgressView = ProgressView(frame: CGRect(x: 0, y: 0, width: 303, height: 60))
    
    var tokenTimer: Timer!
    var token: Token?
    
    var shouldShowCopied: Bool = false
    var copiedCount: Int = 5
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        user.font = .systemFont(ofSize: 14)
        
        time.font = UIFont(name: "SourceCodePro-ExtraLight", size: 14)
        time.textAlignment = .right

        code.font = UIFont(name: "SourceCodePro-ExtraLight", size: 20)
        code.textAlignment = .right
        
        progress.trackColor = .clear
        progress.separatorColor = .clear
        progress.progressColor = UIColor.flatSkyBlue.withAlphaComponent(0.4)
        progress.isUserInteractionEnabled = false
        
        addSubview(mainView)

        mainView.addSubview(progress)
        mainView.addSubview(provider)
        mainView.addSubview(user)
        mainView.addSubview(code)
        mainView.addSubview(time)
        
        let copyGesture = UITapGestureRecognizer(target: self, action: #selector(CodeTableViewCell.prepareForCopy))
        code.addGestureRecognizer(copyGesture)
        code.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    @objc func prepareForCopy() {
        let code = token?.currentPassword
        UIPasteboard.general.string = code

        shouldShowCopied = true
        
        let s = UISelectionFeedbackGenerator()
        s.selectionChanged()
    }
    
    override func layoutSubviews() {
        mainView.backgroundColor = UIColor.flatBlack.lighten(byPercentage: 0.05)
        
        mainView.anchorInCenter(width: width * 0.95, height: 60)
        mainView.layer.cornerRadius = 15
        
        progress.layer.cornerRadius = 15
        progress.layer.borderColor = UIColor.flatBlueDark.cgColor
        progress.layer.borderWidth = 1.5
        
        provider.anchorInCorner(.topLeft, xPad: 12, yPad: 10, width: width * 0.6, height: 20)
        user.anchorInCorner(.bottomLeft, xPad: 12, yPad: 10, width: width * 0.6, height: 16)
        
        code.anchorInCorner(.topRight, xPad: 10, yPad: 10, width: width * 0.48, height: 20)
        time.anchorInCorner(.bottomRight, xPad: 10, yPad: 10, width: width * 0.48, height: 16)
    }

    func configure(with t: Token) {
        provider.text = t.issuer
        user.text = t.name
        
        token = t
        
        updateCode()
        startTimer()
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
            return Float(30 - d)
        default: return 0.0
        }
    }
    
    func stopTimer() {
        guard tokenTimer != nil else { return }
        tokenTimer.invalidate()
    }
    
    func startTimer() {
        let t = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (_) in
            let r = self.timeRemaining()
            let p = Float(r/30)
            self.progress.animateProgress(to: p)
            
            let t: Int = 30 - Int(r)
            
            self.time.updateText(with: "\(t)s", duration: 0.3)
            
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
