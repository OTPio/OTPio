//
//  MenuController.swift
//  otpio
//
//  Created by Mason Phillips on 2/13/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit
import Neon
import LibFA

class MenuController: BaseTableViewController {
    var router: RouterInterface {
        return assembler.resolver.resolve(RouterInterface.self)!
    }
    
    var headerView: UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 150))
    }
    
    override func viewDidLoad() {
        tableView.register(MenuCell.self, forCellReuseIdentifier: MenuCell.identifier)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let index = router.currentOption.rawValue
        for c in tableView.visibleCells {
            (c as! MenuCell).mark(false)
        }
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))! as! MenuCell
        cell.mark(true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NavigationOption.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.identifier, for: indexPath) as! MenuCell
        cell.config(with: NavigationOption.allCases[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = NavigationOption(rawValue: indexPath.row)!
        router.move(to: option)
    }
}

class MenuCell: UITableViewCell {
    static let identifier: String = "menuCell"
    
    let iconLabel: UILabel = UILabel(frame: .zero)
    let nameLabel: UILabel = UILabel(frame: .zero)
    
    let activeIndicator: CALayer = CALayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconLabel.font = UIFont.fontAwesome(ofSize: 20, style: .regular)
        iconLabel.textColor = .black
        nameLabel.textColor = .black
        
//        selectionStyle = .none
        
        activeIndicator.frame = CGRect(x: 0, y: 0, width: 5, height: contentView.height)
        activeIndicator.backgroundColor = UIColor.blue.cgColor
        
        contentView.addSubview(iconLabel)
        contentView.addSubview(nameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconLabel.anchorToEdge(.left, padding: 20, width: 25, height: 25)
        nameLabel.alignAndFillWidth(align: .toTheRightCentered, relativeTo: iconLabel, padding: 10, height: 25)
    }
    
    func config(with o: NavigationOption) {
        iconLabel.text = String.fontAwesomeIcon(name: o.icon)
        nameLabel.text = o.title
    }
    
    func mark(_ selected: Bool) {
        if selected {
            contentView.layer.addSublayer(activeIndicator)
        } else {
            activeIndicator.removeFromSuperlayer()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
