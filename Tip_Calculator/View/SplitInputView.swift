//
//  SplitInputView.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 5.03.2024.
//

import UIKit
import Combine
import CombineCocoa

class SplitInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Split", bottomText: "the total")
        return view
    }()
    
    private lazy var decrementBtn: UIButton = {
        let btn = buildBtn(text: "-", corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        btn.tapPublisher.flatMap { [unowned self] _ in
            Just(splitSubject.value == 1 ? 1 : splitSubject.value - 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellable)
        return btn
    }()
    
    private lazy var incrementBtn: UIButton = {
        let btn = buildBtn(text: "+", corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        btn.tapPublisher.flatMap { [unowned self] _ in
            Just(splitSubject.value + 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellable)
        return btn
    }()
    
    private lazy var quantityLbl: UILabel = {
        let lbl = LabelFactory.build(text: "1", font: ThemeFont.bold(ofSize: 20), backgroundColor: .white)
        return lbl
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
        decrementBtn,
        quantityLbl,
        incrementBtn
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
    }()
    
    private let splitSubject: CurrentValueSubject<Int, Never> = .init(1)
    var valuePublisher: AnyPublisher<Int, Never> {
        return splitSubject.removeDuplicates().eraseToAnyPublisher()
    }
    
    private var cancellable = Set<AnyCancellable>()

    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        splitSubject.send(1)
    }
    
    private func layout() {
        [headerView,stackView].forEach(addSubview(_:))
        
        stackView.snp.makeConstraints{ make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        [incrementBtn, decrementBtn].forEach{ btn in
            btn.snp.makeConstraints{ make in
                make.width.equalTo(btn.snp.height)
            }
        }
        
        headerView.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(stackView.snp.centerY)
            make.trailing.equalTo(stackView.snp.leading).offset(-24)
            make.width.equalTo(68)
        }
    }
    
    private func observe() {
        splitSubject.sink { [unowned self] quantity in
            quantityLbl.text = quantity.stringValue
        }.store(in: &cancellable)
    }
    
    private func buildBtn(text: String, corners: CACornerMask) -> UIButton{
        let btn = UIButton()
        btn.setTitle(text, for: .normal)
        btn.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        btn.backgroundColor = ThemeColor.primary
        btn.addRounderCorners(corners: corners, radius: 8.0)
        return btn
    }
}
