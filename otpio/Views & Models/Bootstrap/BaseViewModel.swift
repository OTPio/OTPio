//
//  BaseViewModel.swift
//  otpio
//
//  Created by Mason Phillips on 2/11/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Swinject

class BaseViewModel {
    let assembler: Assembler
    
    required init(_ assembler: Assembler) {
        self.assembler = assembler
    }
}
