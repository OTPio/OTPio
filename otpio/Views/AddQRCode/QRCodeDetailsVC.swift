//
//  QRCodeDetailsVC.swift
//  otpio
//
//  Created by Mason Phillips on 11/13/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import libtoken
import Eureka
import Base32

class QRCodeDetailsVC: FormViewController {
    var outlet: AddQRCodePageController?
    var token: Token!
    
    var rightBar: UIBarButtonItem {
        let b = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(QRCodeDetailsVC.saveData))
        return b
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .flatBlack
        
        form +++ Section("Token Details")
            <<< TextRow(CellTags.secret.rawValue) { row in
                row.title = "Secret"
            }
            <<< TextRow(CellTags.user.rawValue) { row in
                row.title = "User"
            }
            <<< TextRow(CellTags.issuer.rawValue) { row in
                row.title = "Issuer"
            }
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
                }
            <<< StepperRow("digitsRow") { row in
                row.title = "Digits"
                row.value = 6.0
                row.cell.stepper.stepValue = 1.0
                row.cell.stepper.maximumValue = 8.0
                row.cell.stepper.minimumValue = 6.0
                row.disabled = true
                
                row.hidden = Condition.function([CellTags.advanced.rawValue], { (form) -> Bool in
                    return !((form.rowBy(tag: CellTags.advanced.rawValue) as? SwitchRow)?.value ?? false)
                })
                }
            <<< StepperRow(CellTags.interval.rawValue) { row in
                row.title = "Interval"
                row.value = 30.0
                row.cell.stepper.stepValue = 1.0
                row.disabled = true
                
                row.hidden = Condition.function([CellTags.advanced.rawValue], { (form) -> Bool in
                    return !((form.rowBy(tag: CellTags.advanced.rawValue) as? SwitchRow)?.value ?? false)
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
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        outlet?.navigationItem.title = "Token Details"
        outlet?.navigationItem.rightBarButtonItem = rightBar
        
        guard let t = outlet?.token else { return }
        self.token = t
        
        if let labelRow = form.rowBy(tag: CellTags.user.rawValue) as? TextRow {
            labelRow.value = t.label
            labelRow.updateCell()
        }
        if let issuerRow = form.rowBy(tag: CellTags.issuer.rawValue) as? TextRow {
            issuerRow.value = t.issuer
            issuerRow.updateCell()
        }
        if let secretRow = form.rowBy(tag: CellTags.secret.rawValue) as? TextRow {
            secretRow.value = MF_Base32Codec.base32String(from: t.secret)
            secretRow.updateCell()
        }
    }
    
    @objc func saveData() {
        guard let label  = (form.rowBy(tag: CellTags.user.rawValue))?.baseValue as? String else { return }
        guard let issuer = (form.rowBy(tag: CellTags.issuer.rawValue))?.baseValue as? String else { return }
        guard let secret = (form.rowBy(tag: CellTags.secret.rawValue))?.baseValue as? String else { return }
        guard let sData  = MF_Base32Codec.data(fromBase32String: secret) else { return }
        
        let t = Token(secret: sData, issuer: issuer, label: label)
        outlet?.set(token: t)
        
        outlet?.confirmCode()
    }
}
