//
//  CalculatorViewModel.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 6.03.2024.
//

import Foundation
import Combine

class CalculatorVM{
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher <Result, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        
        let result = Result(amounPerPerson: 500, totalBill: 1000, totalTip: 50.0)
        return Output(updateViewPublisher: Just(result).eraseToAnyPublisher())
        
    }
    
}
