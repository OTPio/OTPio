//
//  HomeModel.swift
//  otpio
//
//  Created by Mason Phillips on 2/13/19.
//  Copyright © 2019 Matrix Studios. All rights reserved.
//

import Foundation
import Swinject
import RxSwift
import RxCocoa
import LibToken

protocol HomeModelInput {
    
}
protocol HomeModelOutput {
    
}

class HomeModel: BaseViewModel {
    private let tokens: BehaviorRelay<[Token]>
    
    required init(_ assembler: Assembler) {
        tokens = BehaviorRelay<[Token]>(value: [])
        
        super.init(assembler)
    }
}

protocol HomeModelType {
    var input : HomeModelInput { get }
    var output: HomeModelOutput { get }
}
extension HomeModel: HomeModelType {
    var input : HomeModelInput { return self }
    var output: HomeModelOutput { return self }
}

extension HomeModel: HomeModelInput {
    
}
extension HomeModel: HomeModelOutput {
    
}
