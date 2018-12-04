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
        <<< IconRow(TokenCellTags.icon.rawValue) { row in
            row.title = "Selected Icon"
        }

        +++ Section(header: "Advanced Details", footer: fetchString(forKey: "advanced-token"))
        <<< SwitchRow(TokenCellTags.advanced.rawValue) { row in
            row.title = "Show Advanced Details"
            row.value = false
        }
        <<< ActionSheetRow<String>(TokenCellTags.hash.rawValue) { row in
            row.title = "Hash"
            row.options = algorithmsMapped
            row.hidden = Condition.function([TokenCellTags.advanced.rawValue], { (form) -> Bool in
                return !((form.rowBy(tag: TokenCellTags.advanced.rawValue) as? SwitchRow)?.value ?? true)
            })
        }
        <<< StepperRow(TokenCellTags.digits.rawValue) { row in
            row.title = "Digits"
            row.cell.stepper.maximumValue = 8.0
            row.cell.stepper.minimumValue = 6.0
            row.hidden = Condition.function([TokenCellTags.advanced.rawValue], { (form) -> Bool in
                return !((form.rowBy(tag: TokenCellTags.advanced.rawValue) as? SwitchRow)?.value ?? true)
            })
        }
        <<< StepperRow(TokenCellTags.interval.rawValue) { row in
            row.title = "Interval"
            row.cell.stepper.minimumValue = 10.0
            row.cell.stepper.maximumValue = 60.0
            row.hidden = Condition.function([TokenCellTags.advanced.rawValue], { (form) -> Bool in
                return !((form.rowBy(tag: TokenCellTags.advanced.rawValue) as? SwitchRow)?.value ?? true)
            })
        }

        +++ Section("Token Availablility") { section in
            section.tag = "avail"
//            section.hidden = true
        }
        <<< SwitchRow(TokenCellTags.cloud.rawValue) { row in
            row.title = "Stored in iCloud"
        }
        <<< SwitchRow(TokenCellTags.today.rawValue) { row in
            row.title = "Show in Today"
        }
    }
    
    func themeForm() {
        let theme  = ThemingEngine.sharedInstance
        
        let incrementEnabled : UIImage = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: theme.emphasizedText, size: CGSize(width: 20, height: 20))
        let incrementDisabled: UIImage = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: theme.secondaryText.withAlphaComponent(0.4), size: CGSize(width: 20, height: 20))
        let decrementEnabled : UIImage = UIImage.fontAwesomeIcon(name: .minus, style: .solid, textColor: theme.emphasizedText, size: CGSize(width: 20, height: 20))
        let decrementDisabled: UIImage = UIImage.fontAwesomeIcon(name: .minus, style: .solid, textColor: theme.secondaryText.withAlphaComponent(0.4), size: CGSize(width: 20, height: 20))

        for row in form.allRows {
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
                guard let tag = row.tag, tag != TokenCellTags.advanced.rawValue
                    else { continue }
                
                row.onChange { (row) in
                    guard
                        let value = row.value,
                        let cell  = TokenCellTags(rawValue: tag)
                    else { return }
                    self.update(cell: cell, value: value)
                }
            }
            
            if let row = row as? ActionSheetRow<String> {
                row.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = theme.emphasizedText
                    cell.detailTextLabel?.textColor = theme.normalText
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
            
            if let row = row as? IconRow {
                row.cellUpdate { (_, row) in
                    row.theme()
                }
                
                row.onChange { (row) in
                    guard let value = row.value else { return }
                    self.update(cell: .icon, value: value.rawValue)
                }
            }
            
            row.updateCell()
        }
    }
    
    func configure(with t: Token, allowSaves: Bool) {
        self.token = t

        if let row = form.rowBy(tag: TokenCellTags.secret.rawValue) as? TextRow {
            row.value = MF_Base32Codec.base32String(from: t.secret)
//            row.disabled = Condition(booleanLiteral: allowSaves)
//            row.evaluateDisabled()
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
        
        if let row = form.rowBy(tag: TokenCellTags.icon.rawValue) as? IconRow {
            row.issuerName = t.issuer
            row.value = t.faIcon
            
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
        
        if let row = form.rowBy(tag: TokenCellTags.today.rawValue) as? SwitchRow {
            //row.hidden = Condition(booleanLiteral: allowSaves)
            row.value = SystemCommunicator.sharedInstance.isInToday(token: t)
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: TokenCellTags.cloud.rawValue) as? SwitchRow {
            //row.hidden = Condition(booleanLiteral: allowSaves)
            row.value = SystemCommunicator.sharedInstance.isInCloud(token: t)
            row.updateCell()
        }
        
//        if let section = form.sectionBy(tag: "avail") {
//            section.hidden = Condition(booleanLiteral: !allowSaves)
//            section.evaluateHidden()
//            section.reload()
//        }
        
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
        case .hash:
            let hash = TokenAlgorithm(rawValue: v)
            guard self.token.algorithm != hash else { return }
            self.token.algorithm = hash
        default: return
        }
    }
    
    func update(cell t: TokenCellTags, value v: Double) {
        switch t {
        case .digits:
            guard self.token.digits != Int(v) else { return }
            self.token.digits = Int(v)
        case .interval:
            guard self.token.interval != v else { return }
            self.token.interval = v
        default: return
        }
    }
    
    func update(cell t: TokenCellTags, value v: Bool) {
        switch t {
        case .cloud:
            SystemCommunicator.sharedInstance.cloud(token: self.token, available: v)
        case .today:
            SystemCommunicator.sharedInstance.today(token: self.token, available: v)
            break
        default: return
        }
    }
    
    func getToken() -> Token {
        return self.token
    }
}
