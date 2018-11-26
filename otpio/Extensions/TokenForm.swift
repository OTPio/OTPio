//
//  CodeDetailCells.swift
//  otpio
//
//  Created by Mason Phillips on 11/25/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import Foundation
import Eureka
import libtoken
import libfa
import Base32

class TokenForm {
    public static let sharedInstance: TokenForm = TokenForm()
    
    var faMapped: Array<String> = {
        var pre = FontAwesomeBrands.compactMap { return FontAwesome(rawValue: $0.value)! }
        pre.sort { $0.iconName()! < $1.iconName()! }
        let post = pre.map { return $0.rawValue }
        return post
    }()
    
    var algorithmsMapped: Array<String> = [
        TokenAlgorithm.md5.algorithmName(dash: true),
        TokenAlgorithm.sha1.algorithmName(dash: true),
        TokenAlgorithm.sha224.algorithmName(dash: true),
        TokenAlgorithm.sha256.algorithmName(dash: true),
        TokenAlgorithm.sha384.algorithmName(dash: true),
        TokenAlgorithm.sha512.algorithmName(dash: true)
    ]
    
    private var token: Token!
    public var form: Form
    
    init() {
        form = Form()
        
        form
        +++ Section(header: "Token Details", footer: fetchString(forKey: "details-token"))
        <<< TextRow(TokenCellTags.secret.rawValue) { row in
            row.title = "Secret"
            row.disabled = true
        }
        <<< TextRow(TokenCellTags.user.rawValue) { row in
            row.title = "User"
        }
        <<< TextRow(TokenCellTags.issuer.rawValue) { row in
            row.title = "Issuer"
        }
        <<< PushRow<String>(TokenCellTags.icon.rawValue) { row in
            row.title = "Icon"
            row.selectorTitle = "Select an icon"
            row.options = faMapped
        }

        +++ Section(header: "Advanced Details", footer: fetchString(forKey: "advanced-token"))
        <<< SwitchRow(TokenCellTags.advanced.rawValue) { row in
            row.title = "Show Advanced Details"
        }
        <<< ActionSheetRow<String>(TokenCellTags.hash.rawValue) { row in
            row.title = "Hash"
            row.options = algorithmsMapped
        }
        <<< StepperRow(TokenCellTags.digits.rawValue) { row in
            row.title = "Digits"
            row.cell.stepper.maximumValue = 8.0
            row.cell.stepper.minimumValue = 6.0
        }
        <<< StepperRow(TokenCellTags.interval.rawValue) { row in
            row.title = "Interval"
            row.cell.stepper.minimumValue = 10.0
            row.cell.stepper.maximumValue = 60.0
        }

        
        +++ Section(header: "Token Availability", footer: fetchString(forKey: "available-token"))
    }
    
    private func themeForm() {
        let theme  = ThemingEngine.sharedInstance
        
        let incrementEnabled : UIImage = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: theme.emphasizedText, size: CGSize(width: 20, height: 20))
        let incrementDisabled: UIImage = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: theme.secondaryText.withAlphaComponent(0.4), size: CGSize(width: 20, height: 20))
        let decrementEnabled : UIImage = UIImage.fontAwesomeIcon(name: .minus, style: .solid, textColor: theme.emphasizedText, size: CGSize(width: 20, height: 20))
        let decrementDisabled: UIImage = UIImage.fontAwesomeIcon(name: .minus, style: .solid, textColor: theme.secondaryText.withAlphaComponent(0.4), size: CGSize(width: 20, height: 20))

        for row in form.rows {
            row.baseCell.backgroundColor = theme.bgHighlight
            
            if let row = row as? TextRow {
                row.cellUpdate { (cell, _) in
                    cell.titleLabel?.textColor = theme.emphasizedText
                    cell.textField.textColor = theme.normalText
                }
                row.onChange { (row) in
                    guard
                        let value = row.value,
                        let tag   = row.tag,
                        let cell  = TokenCellTags(rawValue: tag)
                    else { return }
                    
                    self.update(cell: cell, value: value)
                }
            }
            
            if let row = row as? PushRow<String> {
                row.cellUpdate { (cell, row) in
                    cell.textLabel?.textColor = theme.emphasizedText
                    cell.detailTextLabel?.font = FABRANDS_UIFONT
                    cell.detailTextLabel?.textColor = theme.normalText
                }
                row.onPresent { (form, to) in
                    to.view.backgroundColor = theme.background
                    to.selectableRowCellUpdate = { cell, row in
                        cell.backgroundColor = theme.background
                        
                        cell.textLabel?.text = row.selectableValue!
                        cell.textLabel?.font = FABRANDS_UIFONT
                        cell.textLabel?.textColor = theme.emphasizedText
                        
                        guard let r = row.selectableValue,
                            let fa = FontAwesome(rawValue: r),
                            let code = fa.iconName()
                            else { return }
                        
                        cell.detailTextLabel?.text = String(code.dropFirst(3))
                        cell.detailTextLabel?.textColor = theme.normalText
                    }
                }
                row.onChange { (row) in
                    guard
                        let value = row.value,
                        let tag   = row.tag,
                        let cell  = TokenCellTags(rawValue: tag)
                    else { return }
                    self.update(cell: cell, value: value)
                }
            }
            
            if let row = row as? SwitchRow {
                row.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = theme.emphasizedText
                    cell.switchControl.onTintColor = .flatGreen
                    cell.switchControl.tintColor = .flatRed
                }
            }
            
            if let row = row as? ActionSheetRow<String> {
                row.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = theme.emphasizedText
                    cell.detailTextLabel?.textColor = theme.normalText
                    
                    row.hidden = Condition.function([TokenCellTags.advanced.rawValue], { (form) -> Bool in
                        return !((form.rowBy(tag: TokenCellTags.advanced.rawValue) as? SwitchRow)?.value ?? false)
                    })
                }
                row.onChange { (row) in
                    guard
                        let value = row.value,
                        let tag   = row.tag,
                        let cell  = TokenCellTags(rawValue: tag)
                    else { return }
                    self.update(cell: cell, value: value)
                }
            }
            
            if let row = row as? StepperRow {
                row.cellUpdate { (cell, row) in
                    cell.textLabel?.textColor = theme.emphasizedText
                    cell.valueLabel?.textColor = theme.normalText
                    cell.stepper.tintColor = theme.border
                    cell.stepper.setIncrementImage(incrementEnabled, for: .normal)
                    cell.stepper.setIncrementImage(incrementDisabled, for: .disabled)
                    cell.stepper.setDecrementImage(decrementEnabled, for: .normal)
                    cell.stepper.setDecrementImage(decrementDisabled, for: .disabled)
                    cell.stepper.stepValue = 1.0
                    
                    row.displayValueFor = { return $0.map { "\(Int($0))" } }
                    row.hidden = Condition.function([TokenCellTags.advanced.rawValue], { (form) -> Bool in
                        return !((form.rowBy(tag: TokenCellTags.advanced.rawValue) as? SwitchRow)?.value ?? false)
                    })
                }
                
            }
            
            row.updateCell()
        }
    }
    
    func configure(with t: Token) {
        self.token = t

        if let row = form.rowBy(tag: TokenCellTags.secret.rawValue) as? TextRow {
            row.value = MF_Base32Codec.base32String(from: t.secret)
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: TokenCellTags.user.rawValue) as? TextRow {
            row.value = t.label
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: TokenCellTags.issuer.rawValue) as? TextRow {
            row.value = t.issuer
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: TokenCellTags.icon.rawValue) as? PushRow<String> {
            row.value = t.faIcon.rawValue
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: TokenCellTags.advanced.rawValue) as? SwitchRow {
            let val: Bool = !(t.algorithm == .sha1 && t.digits == 6 && t.interval == 30.0)
            row.value = val
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: TokenCellTags.hash.rawValue) as? ActionSheetRow<String> {
            row.value = t.algorithm.algorithmName(dash: true)
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: TokenCellTags.digits.rawValue) as? StepperRow {
            row.value = Double(t.digits)
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: TokenCellTags.interval.rawValue) as? StepperRow {
            row.value = t.interval
            row.updateCell()
        }
        
        self.themeForm()
    }
    
    func update(cell t: TokenCellTags, value v: String) {
        switch t {
        case .user:
            guard self.token.label != v else { return }
            self.token.label = v
        case .issuer:
            guard self.token.issuer != v else { return }
            self.token.issuer = v
        case .icon:
            guard
                let icon = FontAwesome(rawValue: v),
                self.token.faIcon != icon
            else { return }
            self.token.faIcon = icon
        default: return
        }
    }
}

//    +++ Section("Token Availibility")
//    <<< SwitchRow(CellTags.cloud.rawValue) { row in
//        row.title = "Stored in iCloud"
//        }.onChange({ (row) in
//            let val = row.value!
//            self.update(row: .cloud, value: val)
//        })
//    <<< SwitchRow(CellTags.today.rawValue) { row in
//        row.title = "Show in Today"
//        }.onChange({ (row) in
//            let val = row.value!
//            self.update(row: .today, value: val)
//        })
//    <<< ButtonRow(CellTags.delete.rawValue) { row in
//        row.title = "Delete Token"
//        
//        }.onCellSelection({ (_, _) in
//            let alert = SCLAlertView()
//            alert.addButton("I'm Sure!", action: {
//                SystemCommunicator.sharedInstance.remove(token: self.token!)
//                self.navigationController?.popToRootViewController(animated: true)
//            })
//            
//            alert.showError("Delete \(self.token!.issuer)", subTitle: fetchString(forKey: "delete-token"), closeButtonTitle: "Keep It!")
//        })
//
//for r in form.allRows {
//    r.baseCell.backgroundColor = .flatBlack
//    
//    if let sr = r as? StepperRow {
//        sr.cellUpdate { (cell, _) in
//        }
//        
//        sr.displayValueFor = {
//            return $0.map { "\(Int($0))" }
//        }
//    }
//    
//    if let tr = r as? TextRow {
//        tr.cellUpdate { (cell, _) in
//            cell.titleLabel?.textColor = .flatWhite
//            cell.textField.textColor = .flatWhite
//        }
//    }
//    
//
//    if let pr = r as? PushRow<String> {
//    }
//    
//    if let br = r as? ButtonRow {
//        br.cellUpdate { (cell, row) in
//            cell.textLabel?.textColor = .flatRed
//        }
//    }
//}

//
//if let hasRow = form.rowBy(tag: CellTags.hash.rawValue) as? ActionSheetRow<String> {
//    hasRow.value = t.algorithm.algorithmName(dash: true)
//    hasRow.updateCell()
//}
//
//if let digRow = form.rowBy(tag: CellTags.digits.rawValue) as? StepperRow {
//    digRow.value = Double(t.digits)
//    digRow.updateCell()
//}
//
//if let intRow = form.rowBy(tag: CellTags.interval.rawValue) as? StepperRow {
//    intRow.value = t.interval
//    intRow.updateCell()
//}
//
//if let todRow = form.rowBy(tag: CellTags.today.rawValue) as? SwitchRow {
//    let v = SystemCommunicator.sharedInstance.isInToday(token: t)
//    todRow.value = v
//    isInToday = v
//    todRow.updateCell()
//}
//
//if let cloRow = form.rowBy(tag: CellTags.cloud.rawValue) as? SwitchRow {
//    let v = SystemCommunicator.sharedInstance.isInCloud(token: t)
//    cloRow.value = v
//    isInCloud = v
//    cloRow.updateCell()
//}
//
//navigationItem.title = t.issuer
