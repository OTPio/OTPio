//
//  DisplayVC.swift
//  otpio
//
//  Created by Mason Phillips on 11/12/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import libfa
import libtoken

class DisplayVC: SystemViewController, TokenOperationsListener {

    let table: CodesTable
    
    var rightBar: UIBarButtonItem {
        let b = UIBarButtonItem(title: String.fontAwesomeIcon(name: .qrcode), style: .plain, target: self, action: #selector(DisplayVC.showQR(sender:)))
        b.setTitleTextAttributes(FAREGULAR_ATTR, for: .normal)
        b.setTitleTextAttributes(FAREGULAR_ATTR, for: .highlighted)

        return b
    }
    
    override init() {
        table = CodesTable()
        super.init()
        
        table.viewsuper = self
        SystemCommunicator.sharedInstance.listener = self
        
        registerForPreviewing(with: self, sourceView: table)
        
        view.addSubview(table)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .flatBlackDark
        
        SystemCommunicator.sharedInstance.allTokens()
        
        navigationController?.navigationBar.barTintColor = .flatBlack
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.flatWhite]
        navigationItem.title = "My Codes"
        navigationItem.rightBarButtonItem = rightBar
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        table.anchorToEdge(.bottom, padding: 40, width: view.width * 0.85, height: view.height * 0.8)
    }
    
    @objc func showQR(sender: UIBarButtonItem) {
        let controller = AddQRCodePageController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func returned(tokens t: Array<Token>) {
        let sorted = t.sorted { $0.label < $1.label }
        table.currentTokens = sorted
        table.reloadData()
    }
    
    func startTimers() {
        for cell in table.visibleCells as! [CodeTableViewCell] {
            cell.startTimer()
        }
    }
    
    func stopTimers() {
        for cell in table.visibleCells as! [CodeTableViewCell] {
            cell.stopTimer()
        }
    }
}

extension DisplayVC: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let index = self.table.indexPathForRow(at: location) else { return nil }
        guard let cell  = self.table.cellForRow(at: index) as? CodeTableViewCell else { return nil }
        guard let token = cell.token else { return nil }
        
        let detail = table.detail
        detail.token = token
        
        previewingContext.sourceRect = cell.frame
        
        return detail
    }
}
