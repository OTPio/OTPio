//
//  CodeDetailVC.swift
//  otpio
//
//  Created by Mason Phillips on 11/14/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import Eureka
import libtoken
import libfa
import Base32

class CodeDetailVC: FormViewController {

    var token: Token?
    
    override var previewActionItems: [UIPreviewActionItem] {
        let delete = UIPreviewAction(title: "Remove", style: .destructive) { (action, controller) in
            
        }
        
        let today = UIPreviewAction(title: "Add to Today Widget", style: .default) { (action, controller) in
            
        }
        
        let cloud = UIPreviewAction(title: "Add to iCloud (Sync)", style: .default) { (action, controller) in
            
        }
        
        return [today, cloud, delete]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .flatBlackDark
        
        form +++ Section("Token Details")
            <<< TextRow("secretRow") { row in
                row.title = "Secret"
                }
            <<< TextRow("labelRow") { row in
                row.title = "User"
                }
            <<< TextRow("issuerRow") { row in
                row.title = "Issuer"
                }
            <<< PushRow<FontAwesome>("iconRow") { row in
                row.title = "Icon"
                row.selectorTitle = "Select an icon"
                var pre = FontAwesomeBrands.compactMap { return FontAwesome(rawValue: $0.value)! }
                pre.sort { $0.rawValue < $1.rawValue }
                row.options = pre
            }
        
        +++ Section("Token Availibility")
            <<< SwitchRow("cloud") { row in
                row.title = "Stored in iCloud"
            }
            <<< SwitchRow("today") { row in
                row.title = "Show in Today"
            }
            
        +++ Section("Advanced Details")
            <<< SwitchRow("showAdvanced") { row in
                row.title = "Show Advanced Options"
                row.value = false
            }
            <<< TextRow("hashMethod") { row in
                row.title = "Hash"
                row.value = "SHA1"
                row.disabled = true
                
                row.hidden = Condition.function(["showAdvanced"], { (form) -> Bool in
                    return !((form.rowBy(tag: "showAdvanced") as? SwitchRow)?.value ?? false)
                })
                }
            <<< StepperRow("digitsRow") { row in
                row.title = "Digits"
                row.value = 6.0
                row.cell.stepper.stepValue = 1.0
                row.cell.stepper.maximumValue = 8.0
                row.cell.stepper.minimumValue = 6.0
                row.disabled = true
                
                row.hidden = Condition.function(["showAdvanced"], { (form) -> Bool in
                    return !((form.rowBy(tag: "showAdvanced") as? SwitchRow)?.value ?? false)
                })
                }
            <<< StepperRow("counterRow") { row in
                row.title = "Interval"
                row.value = 30.0
                row.cell.stepper.stepValue = 1.0
                row.disabled = true
                
                row.hidden = Condition.function(["showAdvanced"], { (form) -> Bool in
                    return !((form.rowBy(tag: "showAdvanced") as? SwitchRow)?.value ?? false)
                })
                }
        
        let i: UIImage = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .flatBlack, size: CGSize(width: 20, height: 20))
        let d: UIImage = UIImage.fontAwesomeIcon(name: .minus, style: .solid, textColor: .flatBlack, size: CGSize(width: 20, height: 20))
        let ig: UIImage = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: UIColor.flatBlack.withAlphaComponent(0.5), size: CGSize(width: 20, height: 20))
        let dg: UIImage = UIImage.fontAwesomeIcon(name: .minus, style: .solid, textColor: UIColor.flatBlack.withAlphaComponent(0.5), size: CGSize(width: 20, height: 20))
        
        for r in form.allRows {
            r.baseCell.backgroundColor = .flatBlack
            
            if let sr = r as? StepperRow {
                sr.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = .flatWhite
                    cell.valueLabel?.textColor = .flatWhite
                    cell.stepper.tintColor = .flatWhite
                    cell.stepper.setIncrementImage(i, for: .normal)
                    cell.stepper.setIncrementImage(ig, for: .disabled)
                    cell.stepper.setDecrementImage(d, for: .normal)
                    cell.stepper.setDecrementImage(dg, for: .disabled)
                }
                
                sr.displayValueFor = {
                    return $0.map { "\(Int($0))" }
                }
            }
            
            if let tr = r as? TextRow {
                tr.cellUpdate { (cell, _) in
                    cell.titleLabel?.textColor = .flatWhite
                    cell.textField.textColor = .flatWhite
                }
            }
            
            if let sr = r as? SwitchRow {
                sr.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = .flatWhite
                    cell.switchControl.onTintColor = .flatGreen
                    cell.switchControl.tintColor = .flatRed
                }
            }
            
            if let pr = r as? PushRow<FontAwesome> {
                pr.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = .flatWhite
                    cell.detailTextLabel?.font = FABRANDS_UIFONT
                }
            }
        }
        
        guard token != nil else { return }
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configure() {
        guard let t = token else { return }
        
        if let secRow = form.rowBy(tag: "secretRow") as? TextRow {
            secRow.value = MF_Base32Codec.base32String(from: t.secret)
            secRow.updateCell()
        }
        if let labRow = form.rowBy(tag: "labelRow") as? TextRow {
            labRow.value = t.label
            labRow.updateCell()
        }
        if let issRow = form.rowBy(tag: "issuerRow") as? TextRow {
            issRow.value = t.issuer
            issRow.updateCell()
        }
        
        if let icoRow = form.rowBy(tag: "iconRow") as? PushRow<FontAwesome> {
            icoRow.value = t.faIcon
            icoRow.updateCell()
        }
        
        navigationItem.title = t.issuer
    }
}
