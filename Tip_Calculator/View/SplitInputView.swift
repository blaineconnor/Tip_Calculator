//
//  SplitInputView.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 5.03.2024.
//

import UIKit

class SplitInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Split", bottomText: "the total")
        return view
    }()
    
    private lazy var decrementBtn: UIButton = {
        let btn = buildBtn(text: "-", corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        return btn
    }()
    
    private lazy var incrementBtn: UIButton = {
        let btn = buildBtn(text: "+", corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
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

    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func buildBtn(text: String, corners: CACornerMask) -> UIButton{
        let btn = UIButton()
        btn.setTitle(text, for: .normal)
        btn.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        btn.backgroundColor = ThemeColor.primary
        btn.addRounderCorners(corners: corners, radius: 8.0)
        return btn
    }
}
