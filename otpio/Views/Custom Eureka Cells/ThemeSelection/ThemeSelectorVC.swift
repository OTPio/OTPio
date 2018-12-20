//
//  ThemeSelectorVC.swift
//  otpio
//
//  Created by Mason Phillips on 12/3/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import Eureka
import libtoken
import FSPagerView

class ThemeSelectorVC: UIViewController, TypedRowControllerType {
    var onDismissCallback: ((UIViewController) -> Void)?
    
    public var row: RowOf<Theme>!
    typealias RowValue = Theme
    
    var pager: FSPagerView = FSPagerView(frame: CGRect())
    
    var rbutton: UIBarButtonItem {
        let b = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(ThemeSelectorVC.done))
        b.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ColorName.solarizedMagenta.color], for: .normal)
        return b
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience public init(_ callback: ((UIViewController) -> ())?) {
        self.init(nibName: nil, bundle: nil)
        onDismissCallback = callback
        
        pager.dataSource = self
        pager.delegate = self
        pager.transformer = FSPagerViewTransformer(type: .overlap)
        
        view.addSubview(pager)
    }
    
    override func viewDidLoad() {
        pager.register(ThemeDisplayFSPCV.self, forCellWithReuseIdentifier: "item")
        
        navigationItem.rightBarButtonItem = rbutton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = ThemingEngine.sharedInstance
        view.backgroundColor = theme.background
        pager.backgroundColor = .clear
    }
    
    @objc func done() {
        let index = pager.currentIndex
        let theme = Theme.allThemes[index]
        
        row.value = theme
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        pager.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: view.height * 0.7)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ThemeSelectorVC: FSPagerViewDataSource {
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "item", at: index) as! ThemeDisplayFSPCV
        
        cell.themeNameLabel.text = Theme.allThemes[index].humanReadableName()
        cell.isUserInteractionEnabled = false
        
        return cell
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return Theme.allThemes.count
    }
}

extension ThemeSelectorVC: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        let theme = Theme.allThemes[index]
        
        UIView.animate(withDuration: 0.5) {
            let colors = theme.colorsForTheme()
            
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: colors[.emphasizedText] as Any]
            self.navigationController?.navigationBar.barTintColor = colors[.bgHighlight]
            self.navigationController?.navigationBar.tintColor = colors[.secondaryText]
            
            self.view.backgroundColor = colors[.background]
            (cell as! ThemeDisplayFSPCV).theme(with: theme)
        }
    }
}
