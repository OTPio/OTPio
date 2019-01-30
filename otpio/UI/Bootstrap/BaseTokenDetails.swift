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
    public       var token: Token? {
        didSet(token) {
            guard let token = token else { return }
            
            secret = token.generator.secret.base32String()
            issuer = token.issuer
            user = token.user
            icon = token.fontAwesome
            algorithm = token.generator.algorithm
            moveFactor = token.generator.moveFactor
            digits = Double(token.generator.digits)
            
            switch moveFactor! {
            case .hotp(let c): interval = Double(c)
            case .totp(let c): interval = Double(c)
            }
            
            self.configure()
        }
    }
    
    private var secret    : String?
    private var issuer    : String?
    private var user      : String?
    private var icon      : FontAwesome?
    private var algorithm : Algorithm?
    private var moveFactor: Generator.MoveFactor?
    private var digits    : Double?
    private var interval  : Double?
    
    var listener: TokenEditReciever? {
        didSet {
            let editSecret = listener!.isAddingToken()
            if let row = form.rowBy(tag: Tag.secret.rawValue) {
                row.disabled = Condition(booleanLiteral: !editSecret)
                row.evaluateDisabled()
            }
            if let section = form.sectionBy(tag: STag.initialToken.rawValue) {
                section.hidden = Condition(booleanLiteral: !editSecret)
                section.evaluateHidden()
            }
        }
    }
    
    init() {
        form = Form()
        
        form
            +++ Section(fetchString(forKey: "add-token"))
            { $0.tag = STag.initialToken.rawValue; $0.hidden = true }
            <<< LabelRow(Tag.camera.rawValue).onCellSelection({ (_, _) in
                self.listener?.showCamera()
            })
            +++ Section(header: "Token Details", footer: fetchString(forKey: "details-token"))
            { $0.tag = STag.available.rawValue }
            <<< TextRow(Tag.secret.rawValue)
            <<< TextRow(Tag.user.rawValue)
            <<< TextRow(Tag.issuer.rawValue)
            <<< IconRow(Tag.icon.rawValue)
        
            +++ Section(header: "Advanced Details", footer: fetchString(forKey: "advanced-token"))
            { $0.tag = STag.advanced.rawValue }
            <<< SwitchRow(Tag.advanced.rawValue) { row in
                row.value = false
            }
            <<< ActionSheetRow<Algorithm>(Tag.hash.rawValue) { row in
                row.value = Algorithm.sha1
                row.options = Algorithm.allCases
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
        configure()
    }
    
    @objc func theme(with t: Any) {
        guard let theme = t as? Theme else {
            return
        }
        
        let colors = theme.colorsForTheme()
        
        for row in form.allRows {
            row.baseCell.backgroundColor = colors.backgroundColor
            row.title = Tag(rawValue: row.tag!)!.rowTitle
            
            if let row = row as? LabelRow {
                row.cellUpdate { (cell, _) in
                    cell.textLabel?.textColor = colors.emphasizedText
                    cell.textLabel?.textAlignment = .center
                }
            }
            
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
            
            if let row = row as? ActionSheetRow<Algorithm> {
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
    
    func configure() {
        if let row = form.rowBy(tag: Tag.secret.rawValue) as? TextRow {
            row.value = secret
            row.evaluateDisabled()
            row.onChange { (row) in
                self.secret = row.value
            }
            row.updateCell()
        }

        if let row = form.rowBy(tag: Tag.user.rawValue) as? TextRow {
            row.value = user
            row.onChange { (row) in
                self.user = row.value
            }
            row.updateCell()
        }

        if let row = form.rowBy(tag: Tag.issuer.rawValue) as? TextRow {
            row.value = issuer
            row.onChange { (row) in
                self.issuer = row.value
                if let iconRow = self.form.rowBy(tag: Tag.icon.rawValue) as? IconRow {
                    iconRow.issuerName = row.value
                    iconRow.updateCell()
                }
            }
            row.updateCell()
        }

        if let row = form.rowBy(tag: Tag.icon.rawValue) as? IconRow {
            row.issuerName = issuer
            row.currentIcon = icon
            row.onChange { (row) in
                self.icon = row.value
            }
            row.updateCell()
        }

        if let row = form.rowBy(tag: Tag.hash.rawValue) as? ActionSheetRow<Algorithm> {
            row.value = algorithm
            row.onChange { (row) in
                self.algorithm = row.value
            }
            row.updateCell()
        }

        if let row = form.rowBy(tag: Tag.digits.rawValue) as? StepperRow {
            row.value = digits
            row.onChange { (row) in
                self.digits = row.value
            }
            row.updateCell()
        }

        if let row = form.rowBy(tag: Tag.interval.rawValue) as? StepperRow {
            row.value = interval
            row.onChange { (row) in
                self.interval = row.value
            }
            row.updateCell()
        }

        if let row = form.rowBy(tag: Tag.cloud.rawValue) as? SwitchRow {
            row.updateCell()
        }

        if let row = form.rowBy(tag: Tag.today.rawValue) as? SwitchRow {
            row.updateCell()
        }
        
        theme(with: ThemeEngine.sharedInstance.currentTheme)
    }
    
    func clearForm() {
        
    }
}

protocol TokenEditReciever {
    func showCamera()
    func done(finalToken t: Token)
    func isAddingToken() -> Bool
}
