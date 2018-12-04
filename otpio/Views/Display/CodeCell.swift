//
//  CodeTableViewCell.swift
//  otpio
//
//  Created by Mason Phillips on 10/11/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import libtoken
import libfa
import SwipeCellKit
import RetroProgress

class CodeTableViewCell: SwipeTableViewCell {
    
    let mainView: SystemView  = SystemView()
    
    let icon    : SystemLabel = SystemLabel(withFA: FontAwesomeStyle.brands, textPosition: .center, size: 15)
    let provider: SystemLabel = SystemLabel()
    let user    : SystemLabel = SystemLabel()
    let code    : SystemLabel = SystemLabel()
    let time    : SystemLabel = SystemLabel()
    
    var progress: ProgressView
    
    var tokenTimer: Timer!
    var token: Token?
    
    var cellType: CellType = .expanded
    
    var shouldShowCopied: Bool = false
    var copiedCount: Int = 5
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        progress = ProgressView(frame: CGRect())
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        addSubview(mainView)
        
        mainView.addSubview(icon)
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
        if cellType == .compact {
            mainView.anchorInCenter(width: width * 0.95, height: 60)

            progress.fillSuperview()
            
            icon.anchorInCorner(.topLeft, xPad: 12, yPad: 12, width: 20, height: 20)
            user.anchorInCorner(.bottomLeft, xPad: 12, yPad: 10, width: width * 0.6, height: 16)
            
            code.anchorInCorner(.topRight, xPad: 10, yPad: 10, width: width * 0.35, height: 20)
            time.anchorInCorner(.bottomRight, xPad: 10, yPad: 10, width: width * 0.48, height: 16)
            
            provider.alignBetweenHorizontal(align: .toTheRightCentered, primaryView: icon, secondaryView: code, padding: 5, height: 20)
            
        } else {
            mainView.anchorInCenter(width: width * 0.95, height: 120)
            
            icon.anchorInCorner(.topLeft, xPad: 5, yPad: 5, width: 22, height: 22)
            provider.alignAndFillWidth(align: .toTheRightCentered, relativeTo: icon, padding: 10, height: 22, offset: 0)
            
            progress.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 30)
            
            time.rightInset = 5
            time.align(.aboveMatchingRight, relativeTo: progress, padding: 0, width: width * 0.4, height: 24)
            
            code.alignAndFillWidth(align: .toTheLeftCentered, relativeTo: time, padding: 15, height: 24, offset: 0)
            
            user.alignBetweenVertical(align: .underCentered, primaryView: provider, secondaryView: code, padding: 5, width: width * 0.9)
        }
        
        mainView.layer.cornerRadius = 15
        mainView.layer.borderWidth  = 1.5
        
        progress.trackColor = .clear
        progress.separatorColor = .clear
        progress.isUserInteractionEnabled = false
        
        progress.layer.cornerRadius = 15
        progress.layer.borderWidth = 1.5
    }
    
    func configure(with t: Token) {
        provider.text = t.issuer
        user.text = t.label
        
        icon.text = String.fontAwesomeIcon(name: t.faIcon)
        
        token = t
        
        updateCode()
        stopTimer()
        startTimer()
        theme()
    }
    
    func theme(_ for: Theme? = nil) {
        let theme = (`for` ?? ThemingEngine.sharedInstance.currentTheme).colorsForTheme()
        
        backgroundColor = theme[.bgHighlight]
        
        icon.textColor = theme[.normalText]
        provider.textColor = theme[.normalText]
        user.textColor = theme[.secondaryText]
        code.textColor = theme[.emphasizedText]
        time.textColor = theme[.secondaryText]
        
        mainView.layer.borderColor  = theme[.border]!.cgColor
        
        progress.progressColor = theme[.progressTrack]
        
        switch cellType {
        case .compact:
            user.font = .systemFont(ofSize: 14)
            
            time.font = UIFont(name: "SourceCodePro-ExtraLight", size: 14)
            time.textAlignment = .right
            
            code.font = UIFont(name: "SourceCodePro-ExtraLight", size: 20)
            code.textAlignment = .right
            
            progress.layer.borderColor = theme[.border]!.cgColor
        case .expanded:
            provider.font = .systemFont(ofSize: 20)
            
            time.font = UIFont(name: "SourceCodePro-ExtraLight", size: 20)
            time.textAlignment = .right
            code.font = UIFont(name: "SourceCodePro-ExtraLight", size: 20)
            code.textAlignment = .left
            
            progress.layer.borderColor = theme[.border]!.withAlphaComponent(0.5).cgColor
        }
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
        if tokenTimer != nil { tokenTimer.invalidate() }
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
