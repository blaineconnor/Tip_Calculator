//
//  ViewController.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 4.03.2024.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorVC: UIViewController {
    
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let vm = CalculatorVM()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
         return tapGesture.tapPublisher.flatMap{ _ in
            Just(())
         }.eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        logoView.addGestureRecognizer(tapGesture)
         return tapGesture.tapPublisher.flatMap{ _ in
            Just(())
         }.eraseToAnyPublisher()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        observe()
    }
    
    private func bind() {
        
        let input = CalculatorVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher, logoViewTapPublisher: logoViewTapPublisher)
        
        let output = vm.transform(input: input)
        
        output.updateViewPublisher.sink { [unowned self] result in
            resultView.configure(result: result)
        }.store(in: &cancellables)
        
        output.resetCalculatorPublisher.sink{ [unowned self]_ in
            billInputView.reset()
            tipInputView.reset()
            splitInputView.reset()
            
            UIView.animate(withDuration: 0.1, delay: 0.1, usingSpringWithDamping: 5.0, initialSpringVelocity: 0.5,
                           options: .curveEaseInOut) {
                self.logoView.transform = .init(scaleX: 1.5, y: 1.5 )
            } completion: { _ in
                UIView.animate(withDuration: 0.1, delay: 0.1) {
                    self.logoView.transform = .identity
                }
            }
        }.store(in: &cancellables)
    }
    
    private func observe(){
        viewTapPublisher.sink{[unowned self] value in
            view.endEditing(true)
        }.store(in: &cancellables)
    }
    
    private func layout(){
        view.addSubview(vStackView)
        view.backgroundColor = ThemeColor.bg
        
        
        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
        }
        
        logoView.snp.makeConstraints{ make in
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
        }
        
        resultView.snp.makeConstraints{ make in
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
        
        billInputView.snp.makeConstraints{ make in
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
        }
        
        tipInputView.snp.makeConstraints{ make in
            make.height.equalTo(view.snp.height).multipliedBy(0.2)
        }
        
        splitInputView.snp.makeConstraints{ make in
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
        }
    }
    
    
}

