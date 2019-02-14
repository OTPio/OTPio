//
//  ThemeManager.swift
//  otpio
//
//  Created by Mason Phillips on 2/12/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import Swinject
import RxSwift
import RxCocoa
import SwiftyUserDefaults

class ThemeManager {
    private let assembler: Assembler
    private let currentTheme: BehaviorRelay<Theme>
    
    init(_ assembler: Assembler) {
        self.assembler = assembler
        
        let cu = Defaults[.currentTheme]
        currentTheme = BehaviorRelay<Theme>(value: cu)
    }
}

protocol ThemeInput {
    func set(_ theme: Theme)
}
protocol ThemeOutput {
    var themeDriver: Driver<Theme> { get }
}
extension ThemeManager: ThemeInput {
    func set(_ theme: Theme) {
        currentTheme.accept(theme)
    }
}
extension ThemeManager: ThemeOutput {
    var themeDriver: Driver<Theme> {
        return currentTheme.asDriver().distinctUntilChanged()
    }
}
