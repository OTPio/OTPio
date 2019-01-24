//
//  ThemeRow.swift
//  otpio
//
//  Created by Mason Phillips on 12/3/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import SCLAlertView
import Eureka

final class ThemeRow: OptionsRow<PushSelectorCell<Theme>>, PresenterRowType, RowType {
    
    public typealias PresenterRow = ThemeSelectorVC
    public var presentationMode: PresentationMode<PresenterRow>?
    public var onPresentCallback: ((FormViewController, PresenterRow) -> Void)?
    
    public required init(tag: String?) {
        super.init(tag: tag)
        
        presentationMode = .show(controllerProvider: ControllerProvider.callback {
            return ThemeSelectorVC() { _ in }
            }, onDismiss: { vc in
                _ = vc.navigationController?.popViewController(animated: true)
        })

        displayValueFor = { (value: Theme?) in
            guard let value = value else { return nil }
            return value.humanReadableName()
        }
    }
    
    override func customDidSelect() {
        if !SystemCommunicator.sharedInstance.hasBought() {
            let alert = SCLAlertView()
            alert.addButton("Support Me!", action: {
                SystemCommunicator.sharedInstance.buyThemes()
            })
            
            alert.addButton("Restore Purchases") {
                SystemCommunicator.sharedInstance.restorePuchase()
            }
            
            alert.showInfo("Extra Stuff", subTitle: fetchString(forKey: "purchase-themes"), closeButtonTitle: "No thanks")
        } else {
            super.customDidSelect()
            
            guard let presentationMode = presentationMode, !isDisabled else { return }
            if let controller = presentationMode.makeController() {
                controller.row = self
                controller.title = "Select a Theme"
                
                onPresentCallback?(cell.formViewController()!, controller)
                presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
            } else {
                presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
            }
        }
    }
    
    func theme() {
        let theme = self.value?.colorsForTheme()
        
        cell.textLabel?.textColor = theme![.emphasizedText]
        cell.textLabel?.backgroundColor = .clear
        cell.detailTextLabel?.textColor = theme![.normalText]
        cell.detailTextLabel?.backgroundColor = .clear
    }
}
