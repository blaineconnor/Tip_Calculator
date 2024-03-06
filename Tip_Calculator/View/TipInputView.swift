//
//  TipInputView.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 5.03.2024.
//

import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Choose", bottomText: "your tip")
        return view
    }()
    
    private lazy var tenPercentTipBtn: UIButton = {
        let btn = buildTipBtn(tip: .tenPercent)
        btn.tapPublisher.flatMap({
            Just(Tip.tenPercent)
        }).assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return btn
    }()
    
    private lazy var fifteenPercentTipBtn: UIButton = {
        let btn = buildTipBtn(tip: .fifteenPercent)
        btn.tapPublisher.flatMap({
            Just(Tip.fifteenPercent)
        }).assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return btn
    }()
    
    private lazy var twentyPercentTipBtn: UIButton = {
        let btn = buildTipBtn(tip: .twentyPercent)
        btn.tapPublisher.flatMap({
            Just(Tip.twentyPercent)
        }).assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return btn
    }()
    
    private lazy var customTipBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Custom tip", for: .normal)
        btn.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        btn.backgroundColor = ThemeColor.primary
        btn.tintColor = .white
        btn.addCornerRadius(radius: 8.0)
        btn.tapPublisher.sink{ [weak self] _ in
            self?.handleCustomTipBtn()
        }.store(in: &cancellables)
        return btn
    }()
    
    private lazy var btnHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        tenPercentTipBtn,
        fifteenPercentTipBtn,
        twentyPercentTipBtn
        ])
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var btnVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        btnHStackView,
        customTipBtn
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let tipSubject: CurrentValueSubject<Tip, Never> = .init(.none)
    
    var valuePublisher: AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
    }

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
    
    
    func reset() {
        tipSubject.send(.none)
    }
    
    private func layout() {
        [headerView, btnVStackView].forEach(addSubview(_:))
        
        btnVStackView.snp.makeConstraints{make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(btnVStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
            make.centerY.equalTo(btnHStackView.snp.centerY)
            
        }
    }
    
    private func handleCustomTipBtn(){
        let alertController: UIAlertController = {
            let controller = UIAlertController(title: "Enter custom tip", message: nil, preferredStyle: .alert)
            controller.addTextField { textField in
                textField.placeholder = "Make it generous"
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .no
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let okAction = UIAlertAction(title: "OK", style: .default){ [weak self] _ in
                guard let text = controller.textFields?.first?.text,
                      let value = Int(text) else { return }
                self?.tipSubject.send(.custom(value: value))
            }
            [okAction, cancelAction].forEach(controller.addAction(_:))
            return controller
        }()
        parentViewController?.present(alertController, animated: true)
    }
    
    private func observe(){
        tipSubject.sink { [unowned self] tip in
            resetView()
            switch tip {
            case .none:
                break
            case .tenPercent:
                tenPercentTipBtn.backgroundColor = ThemeColor.secondary
            case .fifteenPercent:
                fifteenPercentTipBtn.backgroundColor = ThemeColor.secondary
            case .twentyPercent:
                twentyPercentTipBtn.backgroundColor = ThemeColor.secondary
            case .custom(let value):
                customTipBtn.backgroundColor = ThemeColor.secondary
                let text = NSMutableAttributedString(string: "₺\(value)", attributes: [.font: ThemeFont.bold(ofSize: 20)])
                text.addAttributes([.font: ThemeFont.bold(ofSize: 14)], range: NSMakeRange(0, 1))
                customTipBtn.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellables)
    }
    
    private func resetView(){
        [tenPercentTipBtn, fifteenPercentTipBtn, twentyPercentTipBtn, customTipBtn].forEach {
            $0.backgroundColor = ThemeColor.primary
        }
        let text = NSMutableAttributedString(string: "Custom tip", attributes: [.font: ThemeFont.bold(ofSize: 20)])
        customTipBtn.setAttributedTitle(text, for: .normal)
    }
    
    private func buildTipBtn(tip: Tip) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = ThemeColor.primary
        
        btn.addCornerRadius(radius: 8.0)
        let text = NSMutableAttributedString(
            string: tip.stringValue,
            attributes: [
                .font: ThemeFont.bold(ofSize: 20), .foregroundColor : UIColor.white
            ])
        text.addAttributes([.font: ThemeFont.demibold(ofSize: 14)], range: NSMakeRange(2, 1))
        btn.setAttributedTitle(text, for: .normal)
    
        return btn
    }
}
