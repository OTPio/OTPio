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

@objc(TodayViewController)

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    let table: UITableView
//    var currentTokens: Array<Token>
    let testItems: Array<String> = ["Hello", "There"]
    
    init() {
        table = UITableView(frame: CGRect())
//        currentTokens = []
        
        super.init(nibName: nil, bundle: nil)
        
        FontBlaster.blast()
        
        table.separatorStyle = .none
        table.register(CodeTableViewCell.self, forCellReuseIdentifier: "code")
        table.dataSource = self
        table.delegate = self
        
        view.addSubview(table)
    }
    
    override func loadView() {
        view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 200.0))
        viewDidLayoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = CGSize(width: 0, height: 200)
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        table.fillSuperview()
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
//        do {
//            let pt = try Keychain.sharedInstance.allPersistentTokens()
//            guard pt.count > 0 else { throw Keychain.Error.incorrectReturnType }
//            for p in pt {
//                self.currentTokens.append(p.token)
//            }
//
//            self.currentTokens = self.currentTokens.sorted(by: { (left, right) -> Bool in
//                return left.issuer < right.issuer
//            })
//
//        } catch let e {
//            print(e)
//            completionHandler(NCUpdateResult.failed)
//        }
//        table.reloadData()
//
//        completionHandler(NCUpdateResult.newData)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return min(2, currentTokens.count)
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "code", for: indexPath) as! CodeTableViewCell
        
//        cell.setup(with: currentTokens[indexPath.row])
        
        return cell
    }    
}
