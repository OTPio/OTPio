//
//  TodayViewController.swift
//  otpio-today
//
//  Created by Mason Phillips on 10/12/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import NotificationCenter
import FontBlaster
import Neon
import libtoken
import KeychainAccess

@objc(TodayViewController)

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    let keychain: Keychain
    
    let table: UITableView
    var currentTokens: Array<Token>
    
    init() {
        table = UITableView(frame: CGRect())
        currentTokens = []
        
        keychain = Keychain(service: "com.otpio.token", accessGroup: "6S4L29QT59.com.otpio.todaykeychain")
        
        super.init(nibName: nil, bundle: nil)
        
        FontBlaster.blast()
        
        table.separatorStyle = .none
        table.register(CodeTableViewCell.self, forCellReuseIdentifier: "code")
        table.dataSource = self
        table.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(table)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        preferredContentSize = CGSize(width: 0, height: 200)
        
        table.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        table.fillSuperview()
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0, height: table.contentSize.height + 10)
        } else {
            preferredContentSize = CGSize(width: 0, height: 200)
        }
        
//        let rect: CGRect = CGRect(x: 0, y: 0, width: maxSize.width, height: table.contentSize.height)
//        view.frame = rect
//        table.frame = rect
        table.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        let all = keychain.allItems()
        currentTokens = all.compactMap({ (input) -> Token? in
            guard let tUrl: String = input["value"] as? String else { return nil }
            guard let url: URL = URL(string: tUrl) else { return nil }
            
            return Token(from: url)
        })
        
        currentTokens = currentTokens.sorted { $0.issuer < $1.issuer }
        
        extensionContext?.widgetLargestAvailableDisplayMode = (currentTokens.count > 2) ? .expanded : .compact
        
        table.reloadData()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTokens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "code", for: indexPath) as! CodeTableViewCell
        
        cell.setup(with: currentTokens[indexPath.row])
        
        return cell
    }    
}
