//
//  CodeTableViewCell.swift
//  otpio
//
//  Created by Mason Phillips on 10/11/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import libtoken
import SwipeCellKit
import RetroProgress

class CodeTableViewCell: SwipeTableViewCell {
    
    let mainView: SystemView  = SystemView()
    
    let provider: SystemLabel = SystemLabel()
    let user    : SystemLabel = SystemLabel()
    let code    : SystemLabel = SystemLabel()
    let time    : SystemLabel = SystemLabel()
    
    var progress: ProgressView
    
    var tokenTimer: Timer!
    var token: Token?
    
    var shouldShowCopied: Bool = false
    var copiedCount: Int = 5
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        progress = ProgressView(frame: CGRect())
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        user.font = .systemFont(ofSize: 14)
        
        time.font = UIFont(name: "SourceCodePro-ExtraLight", size: 14)
        time.textAlignment = .right
        
        code.font = UIFont(name: "SourceCodePro-ExtraLight", size: 20)
        code.textAlignment = .right
        
        
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
        let code = token?.password()
        UIPasteboard.general.string = code
        
        shouldShowCopied = true
        
        let s = UISelectionFeedbackGenerator()
        s.selectionChanged()
    }
    
    override func layoutSubviews() {
        mainView.anchorInCenter(width: width * 0.95, height: 60)
        mainView.layer.cornerRadius = 15
        
        progress.fillSuperview()
        progress.trackColor = .clear
        progress.separatorColor = .clear
        progress.isUserInteractionEnabled = false
        
        progress.layer.cornerRadius = 15
        progress.layer.borderWidth = 1.5
        
        provider.anchorInCorner(.topLeft, xPad: 12, yPad: 10, width: width * 0.6, height: 20)
        user.anchorInCorner(.bottomLeft, xPad: 12, yPad: 10, width: width * 0.6, height: 16)
        
        code.anchorInCorner(.topRight, xPad: 10, yPad: 10, width: width * 0.48, height: 20)
        time.anchorInCorner(.bottomRight, xPad: 10, yPad: 10, width: width * 0.48, height: 16)
    }
    
    func configure(with t: Token) {
        provider.text = t.issuer
        user.text = t.label
        
        token = t
        
        updateCode()
        stopTimer()
        startTimer()
        theme()
    }
    
    func theme() {
        let theme = ThemingEngine.sharedInstance
        
        backgroundColor = theme.bgHighlight
        
        provider.textColor = theme.normalText
        user.textColor = theme.secondaryText
        code.textColor = theme.emphasizedText
        time.textColor = theme.secondaryText
        
        progress.layer.borderColor = theme.border.cgColor
        progress.progressColor = theme.progressTrack
    }
    
    func updateCode() {
        guard let c = token?.password(format: true) else {
            code.text = "Error"; return
        }
        
        code.updateText(with: c, duration: 0.5)
    }
    
    func stopTimer() {
        guard tokenTimer != nil else { return }
        tokenTimer.invalidate()
    }
    
    func startTimer() {
        let t = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (_) in
            let r = self.token!.timeRemaining()
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
