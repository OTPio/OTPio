//
//  CodesTable.swift
//  otpio
//
//  Created by Mason Phillips on 11/13/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import libtoken
import libfa
import Neon
import NVActivityIndicatorView

class CodesTable: UITableView {

    public  var currentTokens: Array<Token> = []
    private let selection    : UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    public var viewsuper: DisplayVC?
    
    public let detail: CodeDetailVC = CodeDetailVC()
    
    let loadingView : SystemView
    let loadingLabel: SystemLabel
    var loadingIcon : NVActivityIndicatorView?
    let noTokenIcon : UIImageView
    
    init() {
        loadingView = SystemView()
        let color = UIColor.flatWhite.withAlphaComponent(0.6)
        noTokenIcon  = UIImageView(image: UIImage.fontAwesomeIcon(name: .lightbulbExclamation, style: .regular, textColor: color, size: CGSize(width: 30, height: 30)))
        loadingLabel = SystemLabel(.center)
        loadingLabel.multiline()
        loadingLabel.textColor = color
        loadingView.addSubview(noTokenIcon)
        loadingView.addSubview(loadingLabel)
        
        super.init(frame: CGRect(), style: .plain)
        
        dataSource = self
        delegate = self
        
        register(CodeTableViewCell.self, forCellReuseIdentifier: "codeCell")
        
        separatorStyle = .none
    }
    
    func theme() {
        backgroundColor = ThemingEngine.sharedInstance.bgHighlight
        
        for cell in visibleCells {
            (cell as! CodeTableViewCell).theme()
        }
    }
    
    func beganLoading() {
        loadingIcon = NVActivityIndicatorView(frame: CGRect(x: center.x - 50, y: center.y - 50, width: 100, height: 100), type: .pacman, color: UIColor.flatWhite.withAlphaComponent(0.6), padding: nil)
        loadingLabel.text = "Loading Tokens..."
        loadingIcon!.startAnimating()
        noTokenIcon.isHidden = true
        loadingView.addSubview(loadingIcon!)
    }
    
    func doneLoading(with a: Array<Token>) {
        if a.count == 0 {
            loadingLabel.text = "No tokens added. Tap the QR Code to add one!"
            loadingIcon!.stopAnimating()
            loadingIcon!.isHidden = true
            noTokenIcon.isHidden = false
        } else {
            self.currentTokens = a
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 15
        
        loadingView.fillSuperview()
        
        guard loadingIcon != nil else { return }
        loadingIcon!.anchorInCenter(width: 100, height: 100)
        noTokenIcon.anchorInCenter(width: 100, height: 100)
        loadingLabel.alignAndFillWidth(align: .underCentered, relativeTo: loadingIcon!, padding: 5, height: 40)
    }
}

extension CodesTable: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let ct: Bool = currentTokens.count > 0
        
        if !ct { backgroundView = loadingView } else { backgroundView = nil }
        
        return ct ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTokens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "codeCell", for: indexPath) as! CodeTableViewCell
        
        let t = currentTokens[indexPath.row]
        cell.configure(with: t)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension CodesTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CodeTableViewCell
        let token = cell.token
        
        detail.configure(with: token!)
        viewsuper?.show(detail, sender: self)
    }
}
