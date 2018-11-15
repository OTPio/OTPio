//
//  AddQRCodePageController.swift
//  otpio
//
//  Created by Mason Phillips on 11/13/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import arek
import libtoken

class AddQRCodePageController: UIPageViewController {

    var token: Token!
    
    private(set) lazy var orderedControllers: [UIViewController] = {
        let cameraView = AddQRCodeVC()
        cameraView.outlet = self
        
        let detailView = QRCodeDetailsVC()
        detailView.outlet = self
        
        let confirmView = ConfirmQRCodeVC()
        confirmView.outlet = self
        
        var views: Array<UIViewController> = []
        
        let permission = ArekCamera()
        permission.manage(completion: { (status) in
            switch status {
            case .authorized: views = [cameraView, detailView, confirmView]
            default: views = [detailView, confirmView]
            }
        })
        
        return views
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    func setupSubviews() {
        if let first = self.orderedControllers.first {
            self.setViewControllers([first], direction: .forward, animated: true, completion: nil)
        } else {
            let t = Timer(timeInterval: 10, repeats: true) { (t) in
                t.invalidate()
                self.setupSubviews()
            }
            t.fire()
        }
    }
    
    @objc func doneScanning(with u: String) {
        let c = orderedControllers[1]
        let url = URL(string: u)!
        let token = Token(from: url)
        self.token = token
        setViewControllers([c], direction: .forward, animated: true, completion: nil)
    }
    
    @objc func confirmCode() {
        let c = orderedControllers.last! as! ConfirmQRCodeVC
        c.token = self.token
        
        setViewControllers([c], direction: .forward, animated: true, completion: nil)
    }
    
    @objc func done() {
        SystemCommunicator.sharedInstance.add(token: self.token)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func set(token t: Token) {
        self.token = t
    }
}
