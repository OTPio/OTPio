//
//  CustomIconRowCell.swift
//  otpio
//
//  Created by Mason Phillips on 12/2/18.
//  Copyright © 2018 Matrix Studios. All rights reserved.
//

import UIKit
import Eureka
import libfa

public final class IconRow: OptionsRow<PushSelectorCell<FontAwesome>>, PresenterRowType, RowType {
    var currentIcon: FontAwesome?
    var issuerName: String?
    
    public typealias PresenterRow = IconSelectorVC
    public var presentationMode: PresentationMode<PresenterRow>?
    public var onPresentCallback: ((FormViewController, PresenterRow) -> Void)?
    
    public required init(tag: String?) {
        super.init(tag: tag)
        
        presentationMode = .show(controllerProvider: ControllerProvider.callback {
            return IconSelectorVC() { _ in }
        }, onDismiss: { vc in
            _ = vc.navigationController?.popViewController(animated: true)
        })
        
        displayValueFor = { (value: FontAwesome?) in
            guard let icon: FontAwesome = value else { return nil }
            return String.fontAwesomeIcon(name: icon)
        }
        
        cell.detailTextLabel?.font = FABRANDS_UIFONT
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        
        guard let presentationMode = presentationMode, !isDisabled else { return }
        if let controller = presentationMode.makeController() {
            controller.row = self
            controller.title = "Select an Icon"
            controller.currentIcon = self.value
            controller.issuer = self.issuerName
            
            controller.initialize()
            
            onPresentCallback?(cell.formViewController()!, controller)
            presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)            
        } else {
            presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
        }
    }
        
    func theme() {
        let theme = ThemingEngine.sharedInstance
        cell.backgroundColor = theme.bgHighlight
        
        cell.textLabel?.textColor = theme.normalText
        cell.detailTextLabel?.textColor = theme.emphasizedText
    }
}
