//
//  BaseViewController.swift
//  otpio
//
//  Created by Mason Phillips on 2/11/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit
import Swinject
import RxSwift
import MMDrawerController

class BaseViewController: UIViewController {
    lazy var assembler: Assembler = AppDelegate.appDelegate.assembler
    let bag           : DisposeBag = DisposeBag()
}

class BaseTableViewController: UITableViewController {
    lazy var assembler: Assembler = AppDelegate.appDelegate.assembler
    let bag           : DisposeBag = DisposeBag()
}

class ParentBaseViewController: BaseViewController {
    var menuButton: MMDrawerBarButtonItem {
        return MMDrawerBarButtonItem(target: self, action: #selector(ParentBaseViewController.openSide))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = menuButton
    }
    
    @objc func openSide() {
        if mm_drawerController.openSide == .left {
            mm_drawerController.closeDrawer(animated: true, completion: nil)
        } else {
            mm_drawerController.open(.left, animated: true, completion: nil)
        }
    }
}
