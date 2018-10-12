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

    init() {
        currentTokens = System.sharedInstance.fetchAll()
        
        super.init(frame: CGRect(), style: UITableView.Style.plain)
        
        System.sharedInstance.listener = self
        register(CodeTableViewCell.self, forCellReuseIdentifier: "code")
        
        dataSource = self
        delegate = self
        
        separatorStyle = .none
        
        backgroundColor = .flatBlack
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 15
    }
}

extension CodesView: TokenOperationsListener {
    func tokensUpdated(tokens t: Array<Token>) {
        self.currentTokens = t
        reloadData()
    }
    
    func stopTimers() {
        for cell in visibleCells as! [CodeTableViewCell] {
            cell.stopTimer()
        }
    }
    
    func restartTimers() {
        for cell in visibleCells as! [CodeTableViewCell] {
            cell.startTimer()
        }
    }
}

extension CodesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension CodesView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
