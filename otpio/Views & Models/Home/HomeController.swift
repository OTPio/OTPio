//
//  HomeController.swift
//  otpio
//
//  Created by Mason Phillips on 2/13/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit
import Neon

class HomeController: ParentBaseViewController {
    let table : UITableView = UITableView(frame: .zero)
    let detail: CodeDetailController = CodeDetailController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(table)
        table.backgroundColor = .blue
        table.separatorStyle = .none
        
        table.register(CodeCell.self, forCellReuseIdentifier: "codeCell")
        table.rx.setDelegate(self).disposed(by: bag)
        
        navigationItem.title = "My Codes"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        table.anchorToEdge(.bottom, padding: 25, width: view.width * 0.9, height: view.height * 0.8)
    }
}

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(detail, animated: true)
    }
}

class CodeCell: UITableViewCell {
    static let identifier: String = "codeCell"
}
