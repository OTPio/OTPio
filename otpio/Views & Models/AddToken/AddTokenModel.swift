//
//  AddTokenModel.swift
//  otpio
//
//  Created by Mason Phillips on 2/13/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import Swinject
import RxSwift
import RxCocoa

protocol AddTokenModelInput {
    var cameraInput: BehaviorRelay<String> { get }
}
protocol AddTokenModelOutput {
    var cameraOutput: Driver<String> { get }
}

class AddTokenModel: BaseViewModel {
    private let cameraPassthrough: BehaviorRelay<String>
    
    required init(_ assembler: Assembler) {
        cameraPassthrough = BehaviorRelay<String>(value: "")
        
        super.init(assembler)
    }
}

extension AddTokenModel: AddTokenModelInput {
    var cameraInput: BehaviorRelay<String> {
        return cameraPassthrough
    }
}
extension AddTokenModel: AddTokenModelOutput {
    var cameraOutput: Driver<String> {
        return cameraPassthrough.asDriver()
    }
}

protocol AddTokenModelType {
    var input : AddTokenModelInput { get }
    var output: AddTokenModelOutput { get }
}
extension AddTokenModel: AddTokenModelType {
    var input : AddTokenModelInput { return self }
    var output: AddTokenModelOutput { return self }
}
