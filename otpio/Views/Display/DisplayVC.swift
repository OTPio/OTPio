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
import arek

class DisplayVC: SystemViewController, TokenOperationsListener {

    let table: CodesTable
    
    var addqr = AddQRCodePageController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var settings: UINavigationController {
        let s = SettingsVC()
        s.outlet = self
        return UINavigationController(rootViewController: s)
    }
    
    let theme = ThemingEngine.sharedInstance
    
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
        
        SystemCommunicator.sharedInstance.allTokens()
        
        navigationItem.title = "My Codes"

        let config = ArekConfiguration(frequency: .JustOnce, presentInitialPopup: true, presentReEnablePopup: false)
        let permissions = ArekCamera(configuration: config, initialPopupData: nil, reEnablePopupData: nil)
        permissions.askForPermission { (_) in
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.backgroundColor = theme.background
        navigationController?.navigationBar.barTintColor = theme.bgHighlight
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: theme.emphasizedText]
        
        let b = UIBarButtonItem(title: String.fontAwesomeIcon(name: .qrcode), style: .plain, target: self, action: #selector(DisplayVC.showQR(sender:)))
        b.setTitleTextAttributes([.foregroundColor: theme.secondaryText, .font: FAREGULAR_UIFONT], for: .normal)
        b.setTitleTextAttributes([.foregroundColor: theme.emphasizedText, .font: FAREGULAR_UIFONT], for: .highlighted)
        navigationItem.leftBarButtonItem = b
        
        let s = UIBarButtonItem(title: String.fontAwesomeIcon(name: .userCog), style: .plain, target: self, action: #selector(DisplayVC.showSettings))
        s.setTitleTextAttributes([.foregroundColor: theme.secondaryText, .font: FAREGULAR_UIFONT], for: .normal)
        s.setTitleTextAttributes([.foregroundColor: theme.emphasizedText, .font: FAREGULAR_UIFONT], for: .highlighted)
        navigationItem.rightBarButtonItem = s
        
        table.theme()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        table.anchorToEdge(.bottom, padding: 40, width: view.width * 0.85, height: view.height * 0.8)
    }
    
    @objc func showQR(sender: UIBarButtonItem) {
        navigationController?.pushViewController(addqr, animated: true)
    }
    
    @objc func showSettings() {
        self.present(settings, animated: true, completion: nil)
    }
    func settingsDone() {
        dismiss(animated: true) {
            self.viewDidAppear(true)
        }
    }
    
    func beganLoading() {
        table.beganLoading()
    }
    
    func returned(tokens t: Array<Token>) {
        let sorted = t.sorted { $0.issuer < $1.issuer }
        table.doneLoading(with: sorted)
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
