//
//  MenuController.swift
//  otpio
//
//  Created by Mason Phillips on 1/23/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    
    private let reuseIdentifier: String = Constants.CellIdentifiers.menu.rawValue
    private let options        : [RouterOption] = RouterOption.allCases
    private let header = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MenuCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.tableHeaderView = header
        tableView.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuController.theme(with:)), name: .themeDidChange, object: ThemeEngine.self)
        theme(with: ThemeEngine.sharedInstance.currentTheme)
        
        guard let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) else {
            fatalError("Could not get first cell")
        }
        (firstCell as! MenuCell).selectionState = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuCell
        cell.configure(with: options[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = options[indexPath.row]
        Router.sharedInstance.switch(to: option)
        
        for cell in tableView.visibleCells {
            guard let c = cell as? MenuCell else {
                fatalError("Could not cast back to type")
            }
            c.selectionState = false
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! MenuCell
        cell.selectionState = true
    }
    
    @objc func theme(with t: Any) {
        guard let theme = t as? Theme else {
            return
        }
        
        let colors = theme.colorsForTheme()
        tableView.backgroundColor = colors.offsetBackground
        header.backgroundColor = colors.offsetBackground
    }
}

class MenuCell: UITableViewCell {
    var option: RouterOption?
    
    let iconLabel: BaseUIL
    let nameLabel: BaseUIL
    
    let selectionLayer: CALayer
    var selectionState: Bool {
        didSet {
            self.setSelected()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        iconLabel = BaseUIL(frame: .zero)
        iconLabel.isSecondary = true
        
        nameLabel = BaseUIL(frame: .zero)
        nameLabel.isEmphasized = true
        
        selectionLayer = CALayer()
        selectionState = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconLabel)
        contentView.addSubview(nameLabel)
        
        selectionLayer.frame = CGRect(x: 0, y: 0, width: 5, height: contentView.height)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuCell.theme(with:)), name: .themeDidChange, object: ThemeEngine.self)
        theme(with: ThemeEngine.sharedInstance.currentTheme)
    }
    
    func configure(with r: RouterOption) {
        iconLabel.font = Font(font: FontFamily.FontAwesome5Pro.regular, size: 19)
        nameLabel.font = UIFont.systemFont(ofSize: 18)

        let data = r.menuItemForOption()
        iconLabel.text = String.fontAwesomeIcon(name: data.f)
        nameLabel.text = data.n
    }
    
    @objc func theme(with t: Any) {
        guard let theme = t as? Theme else {
            return
        }
        
        let colors = theme.colorsForTheme()
        backgroundColor = colors.offsetBackground
        
        selectionLayer.backgroundColor = colors.progressTrack.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconLabel.anchorToEdge(.left, padding: 15, width: 25, height: 25)
        nameLabel.alignAndFillWidth(align: .toTheRightCentered, relativeTo: iconLabel, padding: 7, height: 25)
    }
    
    func setSelected() {
        if selectionState {
            contentView.layer.addSublayer(selectionLayer)
        } else {
            selectionLayer.removeFromSuperlayer()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
