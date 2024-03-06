//
//  TipInputView.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 5.03.2024.
//

import UIKit

class TipInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Choose", bottomText: "your tip")
        return view
    }()
    
    private lazy var tenPercentTipBtn: UIButton = {
        let btn = buildTipBtn(tip: .tenPercent)
        return btn
    }()
    private lazy var fifteenPercentTipBtn: UIButton = {
        let btn = buildTipBtn(tip: .fifteen)
        return btn
    }()
    private lazy var twentyPercentTipBtn: UIButton = {
        let btn = buildTipBtn(tip: .twentyPercent)
        return btn
    }()
    
    private lazy var customTipBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Custom tip", for: .normal)
        btn.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        btn.backgroundColor = ThemeColor.primary
        btn.tintColor = .white
        btn.addCornerRadius(radius: 8.0)
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

    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
