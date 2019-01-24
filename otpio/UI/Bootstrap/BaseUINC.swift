//
//  BaseUINC.swift
//  otpio
//
//  Created by Mason Phillips on 1/23/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit

class BaseUINavController: UINavigationController {
    
    private var preferredStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.preferredStyle
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseUINavController.theme(with:)), name: .themeDidChange, object: ThemeEngine.self)
        theme(with: ThemeEngine.sharedInstance.currentTheme)
    }
    
    @objc func theme(with t: Any) {
        guard let theme = t as? Theme else {
            fatalError("Could not cast back to theme")
        }

        switch theme {
        case .solarizedDark, .nightLightDark:
            preferredStyle = .lightContent
        case .solarizedLight, .nightLightBright:
            preferredStyle = .default
        }
    }
}
