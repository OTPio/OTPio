//
//  CodeTableViewCell.swift
//  otpio
//
//  Created by Mason Phillips on 10/11/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import OneTimePassword

class CodeTableViewCell: UITableViewCell {

    let mainView: SystemView  = SystemView()
    
    let provider: SystemLabel = SystemLabel()
    let user    : SystemLabel = SystemLabel()
    let code    : SystemLabel = SystemLabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainView.backgroundColor = UIColor.flatBlack.lighten(byPercentage: 0.05)
        
        code.font = UIFont(name: "SourceCodeVariable-Roman-ExtraLight", size: 20)
        
        
        addSubview(mainView)
        
        addSubview(provider)
        addSubview(user)
        addSubview(code)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with t: Token) {
        
    }
    
    private func timeRemaining(for t: Token) -> Float {
        switch t.generator.factor {
        case .timer(let time):
            let epoch = Date().timeIntervalSince1970
            let d = Int(time - epoch.truncatingRemainder(dividingBy: time))
            return Float(30 - d)
        default: return 0.0
        }
    }
}
