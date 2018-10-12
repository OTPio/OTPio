//
//  CodesView.swift
//  otpio
//
//  Created by Mason Phillips on 10/11/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import OneTimePassword

class CodesView: UITableView {
    
    private var currentTokens: Array<Token>

    override init(frame: CGRect, style: UITableView.Style) {
        currentTokens = []
        
        super.init(frame: frame, style: style)
        
        System.sharedInstance.listener = self
        register(CodeTableViewCell.self, forCellReuseIdentifier: "code")
        
        backgroundColor = .flatBlack
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 15
    }
}

extension CodesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension CodesView: TokenOperationsListener {
    func tokensUpdated(tokens t: Array<Token>, time: Float) {
        self.currentTokens = t
        reloadData()
    }
}

extension CodesView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTokens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CodeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "code", for: indexPath) as! CodeTableViewCell
        
        let t = currentTokens[indexPath.row]
        cell.configure(with: t)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}
