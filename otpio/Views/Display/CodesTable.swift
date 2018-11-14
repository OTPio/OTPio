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

class CodesTable: UITableView {

    public  var currentTokens: Array<Token> = []
    private let selection    : UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    public let detail: CodeDetailVC = CodeDetailVC()
    
    private var background: SystemView {
        let v = SystemView(frame: self.frame)
        let color = UIColor.flatWhite.withAlphaComponent(0.6)
        let icon  = UIImageView(image: UIImage.fontAwesomeIcon(name: .lightbulbExclamation, style: .regular, textColor: color, size: CGSize(width: 30, height: 30)))
        let label = SystemLabel(.center)
        label.text = "No Codes Added\nTap the QR Icon to add one!"
        label.multiline()
        label.textColor = color
        v.addSubview(icon)
        v.addSubview(label)
        
        icon.anchorInCenter(width: 100, height: 100)
        label.alignAndFillWidth(align: .underCentered, relativeTo: icon, padding: 5, height: 40)

        return v
    }
    
    init() {
        super.init(frame: CGRect(), style: .plain)
        
        dataSource = self
        delegate = self
        
        register(CodeTableViewCell.self, forCellReuseIdentifier: "codeCell")
        
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

extension CodesTable: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let ct: Bool = currentTokens.count > 0
        
        if !ct { backgroundView = background } else { backgroundView = nil }
        
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
    
}
