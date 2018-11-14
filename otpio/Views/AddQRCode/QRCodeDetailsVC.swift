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
        let b = UIBarButtonItem(title: "Save", style: .plain, target: outlet, action: #selector(AddQRCodePageController.confirmCode))
        return b
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flatBlack
        
        form +++ Section("Token Elements")
            <<< TextRow() { row in
                row.title = "Label"
                row.tag = "labelRow"
        }
            <<< TextRow() { row in
                row.title = "Issuer"
                row.tag = "issuerRow"
        }
            <<< TextRow() { row in
                row.title = "Secret"
                row.tag = "secretRow"
        }
            +++ Section("Token Adjusters")
            <<< StepperRow() { row in
                row.title = "Digits"
                row.tag = "digitsRow"
                row.value = 6.0
                row.cell.stepper.stepValue = 1.0
                row.cell.stepper.maximumValue = 8.0
                row.cell.stepper.minimumValue = 6.0
        }
            <<< StepperRow() { row in
                row.title = "Period"
                row.tag = "periodRow"
                row.value = 30.0
                row.cell.stepper.stepValue = 1.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        outlet?.navigationItem.title = "Token Details"
        outlet?.navigationItem.rightBarButtonItem = rightBar
        
        token = outlet?.token
        print(token)
        
        if let labelRow = form.rowBy(tag: "labelRow") as? TextRow {
            labelRow.value = token.label
            labelRow.updateCell()
        }
        if let issuerRow = form.rowBy(tag: "issuerRow") as? TextRow {
            issuerRow.value = token.issuer
            issuerRow.updateCell()
        }
        if let secretRow = form.rowBy(tag: "secretRow") as? TextRow {
            secretRow.value = MF_Base32Codec.base32String(from: token.secret)
            secretRow.updateCell()
        }
    }
}
