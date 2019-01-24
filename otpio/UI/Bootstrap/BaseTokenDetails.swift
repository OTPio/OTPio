//
//  BaseTokenDetails.swift
//  otpio
//
//  Created by Mason Phillips on 1/24/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import UIKit
import Eureka
import LibFA
import LibToken

class BaseTokenDetails {
    public static let sharedInstance: BaseTokenDetails = BaseTokenDetails()
    
    private typealias Tag  = Constants.TokenCellTags
    private typealias STag = Constants.TokenSectionTags
    private typealias StepIcon = Constants.RowItemIcon
    
    private(set) var form : Form
    private      var token: Token?
    
    var listener: TokenEditReciever? {
        didSet {
            let editSecret = listener!.supportsSecretEdit()
            if let row = form.rowBy(tag: Tag.secret.rawValue) {
                row.disabled = Condition(booleanLiteral: !editSecret)
                row.evaluateDisabled()
            }
        }
    }
    
    init() {
        form = Form()
        
        form
            +++ Section(header: "Token Details", footer: "")
            { $0.tag = STag.available.rawValue }
            <<< TextRow(Tag.secret.rawValue)
            <<< TextRow(Tag.user.rawValue)
            <<< TextRow(Tag.issuer.rawValue)
            <<< IconRow(Tag.icon.rawValue)
        
            +++ Section(header: "Advanced Details", footer: "")
            { $0.tag = STag.advanced.rawValue }
            <<< SwitchRow(Tag.advanced.rawValue) { row in
                row.value = false
            }
            <<< ActionSheetRow<TokenAlgorithm>(Tag.hash.rawValue) { row in
                row.value = TokenAlgorithm.default
                row.options = TokenAlgorithm.allCases
                row.hidden = Condition.function([Tag.advanced.rawValue], { (form) -> Bool in
                    return !((form.rowBy(tag: Tag.advanced.rawValue) as? SwitchRow)?.value ?? true)
                })
            }
            <<< StepperRow(Tag.digits.rawValue) { row in
                row.cell.stepper.maximumValue = 8.0
                row.cell.stepper.minimumValue = 6.0
                row.value = 6
                row.cell.stepper.stepValue = 1.0
                row.displayValueFor = { return $0.map { "\(Int($0)) " }}
                row.hidden = Condition.function([Tag.advanced.rawValue], { (form) -> Bool in
                    return !((form.rowBy(tag: Tag.advanced.rawValue) as? SwitchRow)?.value ?? true)
                })
            }
            <<< StepperRow(Tag.interval.rawValue) { row in
                row.cell.stepper.maximumValue = 60.0
                row.cell.stepper.minimumValue = 10.0
                row.value = 30
                row.cell.stepper.stepValue = 1.0
                row.displayValueFor = { return $0.map { "\(Int($0))s" }}
                row.hidden = Condition.function([Tag.advanced.rawValue], { (form) -> Bool in
                    return !((form.rowBy(tag: Tag.advanced.rawValue) as? SwitchRow)?.value ?? true)
                })
            }

            +++ Section(header: "Token Availability", footer: "")
            { $0.tag = STag.available.rawValue }
            <<< SwitchRow(Tag.cloud.rawValue)
            <<< SwitchRow(Tag.today.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseTokenDetails.theme(with:)), name: .themeDidChange, object: ThemeEngine.self)
        setupChanges()
    }
    
    @objc func theme(with t: Any) {
        guard let theme = t as? Theme else {
            return
        }
        
        let colors = theme.colorsForTheme()
        
        for row in form.allRows {
            row.baseCell.backgroundColor = colors.backgroundColor

            if let row = row as? TextRow {
                row.cellUpdate { (cell, _) in
                    cell.titleLabel?.textColor = colors.emphasizedText
                    cell.textField.textColor = colors.normalText
                }
            }
            
            if let row = row as? SwitchRow {
                row.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = colors.emphasizedText
                }
            }
            
            if let row = row as? ActionSheetRow<TokenAlgorithm> {
                row.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = colors.emphasizedText
                    cell.detailTextLabel?.textColor = colors.normalText
                }
            }
            
            if let row = row as? StepperRow {
                row.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = colors.emphasizedText
                    cell.valueLabel?.textColor = colors.normalText
                    cell.stepper.tintColor = colors.border
                    cell.stepper.setIncrementImage(StepIcon.incrementEnabled.image, for: .normal)
                    cell.stepper.setIncrementImage(StepIcon.incrementDisabled.image, for: .disabled)
                    cell.stepper.setDecrementImage(StepIcon.decrementEnabled.image, for: .normal)
                    cell.stepper.setDecrementImage(StepIcon.decrementDisabled.image, for: .disabled)
                }
            }
            
            if let row = row as? IconRow {
                row.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = colors.emphasizedText
                    cell.detailTextLabel?.textColor = colors.normalText
                }
            }
        }
    }
    
    func setupChanges() {
        for row in form.allRows {
            let tag = Tag(rawValue: row.tag!)!
            row.title = tag.rowTitle
            
            if let row = row as? TextRow {
                row.onChange { (row) in
                    guard
                        let value = row.value,
                        let tag   = row.tag,
                        let cell  = Constants.TokenCellTags(rawValue: tag)
                    else { return }
                    self.update(cell: cell, value: value)
                }
            }
        }
        
        theme(with: ThemeEngine.sharedInstance.currentTheme)
    }
    
    func configure(with t: Token) {
        if let row = form.rowBy(tag: Tag.secret.rawValue) as? TextRow {
            row.value = t.secret.base32String()
            row.evaluateDisabled()
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: Tag.user.rawValue) as? TextRow {
            row.value = t.label
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: Tag.issuer.rawValue) as? TextRow {
            row.value = t.issuer
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: Tag.icon.rawValue) as? IconRow {
            row.issuerName = t.issuer
            row.currentIcon = t.faIcon
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: Tag.hash.rawValue) as? ActionSheetRow<TokenAlgorithm> {
            row.value = t.algorithm
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: Tag.digits.rawValue) as? StepperRow {
            row.value = Double(t.digits)
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: Tag.interval.rawValue) as? StepperRow {
            row.value = Double(t.interval)
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: Tag.cloud.rawValue) as? SwitchRow {
            row.updateCell()
        }
        
        if let row = form.rowBy(tag: Tag.today.rawValue) as? SwitchRow {
            row.updateCell()
        }
    }
    
    private func update(cell: Tag, value: String) {
        
    }
    
    private func update(cell: Tag, value: Bool) {
        
    }
    
    private func update(cell: Tag, value: Double) {
        
    }
    
    func clearForm() {
        
    }
}

protocol TokenEditReciever {
    func tokenDidChange()
    func supportsSecretEdit() -> Bool
}
