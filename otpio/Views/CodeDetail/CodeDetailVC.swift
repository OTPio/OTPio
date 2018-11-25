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
import SCLAlertView

class CodeDetailVC: FormViewController {

    var token: Token?
    
    var isInToday: Bool?
    var isInCloud: Bool?
    
    var faMapped: Array<String> = {
        var pre = FontAwesomeBrands.compactMap { return FontAwesome(rawValue: $0.value)! }
        pre.sort { $0.iconName()! < $1.iconName()! }
        let post = pre.map { return $0.rawValue }
        return post
    }()
    
    override var previewActionItems: [UIPreviewActionItem] {
        let delete = UIPreviewAction(title: "Delete Token", style: .destructive) { (action, controller) in
            SystemCommunicator.sharedInstance.remove(token: self.token!)
        }
        
        guard let t = token else { return [delete] }
        
        let td = SystemCommunicator.sharedInstance.isInToday(token: t)
        let cd = SystemCommunicator.sharedInstance.isInCloud(token: t)
        
        let tt = (td) ? "Remove from":"Add to"
        let ct = (cd) ? "Remove from":"Add to"
        
        let today = UIPreviewAction(title: "\(tt) Today Widget", style: .default) { (action, controller) in
            if td { SystemCommunicator.sharedInstance.removeFromToday(token: t) }
            else { SystemCommunicator.sharedInstance.sendToToday(token: t) }
        }
        
        let cloud = UIPreviewAction(title: "\(ct) iCloud (Sync)", style: .default) { (action, controller) in
            if cd { SystemCommunicator.sharedInstance.removeFromCloud(token: t) }
            else { SystemCommunicator.sharedInstance.sendToCloud(token: t) }
        }
        
        return [today, cloud, delete]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .flatBlackDark
        
        form +++ Section(header: "Token Details", footer: fetchString(forKey: "details-token"))
            <<< TextRow(CellTags.secret.rawValue) { row in
                row.title = "Secret"
                row.disabled = true
                }
            <<< TextRow(CellTags.user.rawValue) { row in
                row.title = "User"
                }.onCellHighlightChanged({ (_, row) in
                    self.update(row: .user, value: row.value!)
                })
            <<< TextRow(CellTags.issuer.rawValue) { row in
                row.title = "Issuer"
                }.onCellHighlightChanged({ (_, row) in
                    self.update(row: .issuer, value: row.value!)
                })
            <<< PushRow<String>(CellTags.icon.rawValue) { row in
                row.title = "Icon"
                row.selectorTitle = "Select an icon"
                row.options = faMapped
                }.onChange({ (row) in
                    let val = row.value!
                    self.update(row: .icon, value: val)
                })
            
            +++ Section(header: "Advanced Details", footer: fetchString(forKey: "advanced-token"))
            <<< SwitchRow(CellTags.advanced.rawValue) { row in
                row.title = "Show Advanced Options"
                row.value = false
            }
            <<< TextRow(CellTags.hash.rawValue) { row in
                row.title = "Hash"
                row.value = "SHA1"
                row.disabled = true
                
                row.hidden = Condition.function([CellTags.advanced.rawValue], { (form) -> Bool in
                    return !((form.rowBy(tag: CellTags.advanced.rawValue) as? SwitchRow)?.value ?? false)
                })
                }.onCellHighlightChanged({ (_, row) in
                    self.update(row: .hash, value: row.value!)
                })
            <<< StepperRow("digitsRow") { row in
                row.title = "Digits"
                row.value = 6.0
                row.cell.stepper.stepValue = 1.0
                row.cell.stepper.maximumValue = 8.0
                row.cell.stepper.minimumValue = 6.0
                
                row.hidden = Condition.function([CellTags.advanced.rawValue], { (form) -> Bool in
                    return !((form.rowBy(tag: CellTags.advanced.rawValue) as? SwitchRow)?.value ?? false)
                })
                }.onCellHighlightChanged({ (_, row) in
                    self.update(row: .digits, value: row.value!)
                })
            <<< StepperRow(CellTags.interval.rawValue) { row in
                row.title = "Interval"
                row.value = 30.0
                row.cell.stepper.stepValue = 1.0
                
                row.hidden = Condition.function([CellTags.advanced.rawValue], { (form) -> Bool in
                    return !((form.rowBy(tag: CellTags.advanced.rawValue) as? SwitchRow)?.value ?? false)
                })
                }.onCellHighlightChanged({ (_, row) in
                    self.update(row: .interval, value: row.value!)
                })
        
            +++ Section("Token Availibility")
            <<< SwitchRow(CellTags.cloud.rawValue) { row in
                row.title = "Stored in iCloud"
                }.onChange({ (row) in
                    let val = row.value!
                    self.update(row: .cloud, value: val)
                })
            <<< SwitchRow(CellTags.today.rawValue) { row in
                row.title = "Show in Today"
                }.onChange({ (row) in
                    let val = row.value!
                    self.update(row: .today, value: val)
                })
            <<< ButtonRow(CellTags.delete.rawValue) { row in
                row.title = "Delete Token"
                
                }.onCellSelection({ (_, _) in
                    let alert = SCLAlertView()
                    alert.addButton("I'm Sure!", action: {
                        SystemCommunicator.sharedInstance.remove(token: self.token!)
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                    
                    alert.showError("Delete \(self.token!.issuer)", subTitle: fetchString(forKey: "delete-token"), closeButtonTitle: "Keep It!")
                })

        
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
                
                sr.updateCell()
            }
            
            if let pr = r as? PushRow<String> {
                pr.cellUpdate { (cell, row) in
                    cell.textLabel?.textColor = .flatWhite
                    cell.detailTextLabel?.font = FABRANDS_UIFONT
                    cell.detailTextLabel?.textColor = .flatWhite
                }
                pr.onPresent { (form, to) in
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel?.text = row.selectableValue!
                        cell.textLabel?.font = FABRANDS_UIFONT
                        
                        guard let r = row.selectableValue,
                          let fa = FontAwesome(rawValue: r),
                          let code = fa.iconName()
                        else { return }
                        
                        cell.detailTextLabel?.text = code
                    }
                }
            }
            
            if let br = r as? ButtonRow {
                br.cellUpdate { (cell, row) in
                    cell.textLabel?.textColor = .flatRed
                }
            }
        }
        
        guard token != nil else { return }
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configure()
    }
    
    func configure() {
        guard let t = token else { return }
        
        if let secRow = form.rowBy(tag: CellTags.secret.rawValue) as? TextRow {
            secRow.value = MF_Base32Codec.base32String(from: t.secret)
            secRow.updateCell()
        }
        if let labRow = form.rowBy(tag: CellTags.user.rawValue) as? TextRow {
            labRow.value = t.label
            labRow.updateCell()
        }
        if let issRow = form.rowBy(tag: CellTags.issuer.rawValue) as? TextRow {
            issRow.value = t.issuer
            issRow.updateCell()
        }
        
        if let icoRow = form.rowBy(tag: CellTags.icon.rawValue) as? PushRow<String> {
            icoRow.value = t.faIcon.rawValue
            icoRow.updateCell()
        }
        
        if let digRow = form.rowBy(tag: CellTags.digits.rawValue) as? StepperRow {
            digRow.value = Double(t.digits)
            digRow.updateCell()
        }
        
        if let intRow = form.rowBy(tag: CellTags.interval.rawValue) as? StepperRow {
            intRow.value = t.interval
            intRow.updateCell()
        }
        
        if let todRow = form.rowBy(tag: CellTags.today.rawValue) as? SwitchRow {
            let v = SystemCommunicator.sharedInstance.isInToday(token: t)
            todRow.value = v
            isInToday = v
            todRow.updateCell()
        }
        
        if let cloRow = form.rowBy(tag: CellTags.cloud.rawValue) as? SwitchRow {
            let v = SystemCommunicator.sharedInstance.isInCloud(token: t)
            cloRow.value = v
            isInCloud = v
            cloRow.updateCell()
        }
        
        navigationItem.title = t.issuer
    }
    
    func update(row: CellTags, value: String) {
        guard let t = token else { return }
        
        switch row {
        case .user:
            if t.label == value { return } // Value has not changed
            t.label = value
        case .issuer:
            if t.issuer == value { return }
            t.issuer = value
        case .icon:
            if t.faIcon.rawValue == value { return }
            t.faIcon = FontAwesome(rawValue: value)!
        default: return
        }
        
        SystemCommunicator.sharedInstance.update()
    }
    
    func update(row: CellTags, value: Double) {
        guard let t = token else { return }
        
        switch row {
        case .digits:
            if Double(t.digits) == value { return }
            t.digits = Int(value)
        case .interval:
            if t.interval == value { return }
            t.interval = TimeInterval(value)
        default: return
        }
        
        SystemCommunicator.sharedInstance.update()
    }
    
    func update(row: CellTags, value: Bool) {
        guard let t = token else { return }
        
        switch row {
        case .today:
            guard let v = isInToday else { return }
            if value == v { return }
            if value { SystemCommunicator.sharedInstance.sendToToday(token: t) }
            else { SystemCommunicator.sharedInstance.removeFromToday(token: t) }
        case .cloud:
            guard let v = isInCloud else { return }
            if value == v { return }
            if value { SystemCommunicator.sharedInstance.sendToCloud(token: t) }
            else { SystemCommunicator.sharedInstance.removeFromCloud(token: t) }
        default: return
        }
    }
}

enum CellTags: String {
    case secret   = "secretRow"
    case user     = "userRow"
    case issuer   = "issuerRow"
    case icon     = "iconRow"
    
    case cloud    = "cloudRow"
    case today    = "todayRow"
    case delete   = "deleteRow"
    
    case advanced = "advancedRow"
    case hash     = "hashRow"
    case digits   = "digitsRow"
    case interval = "intervalRow"
}
