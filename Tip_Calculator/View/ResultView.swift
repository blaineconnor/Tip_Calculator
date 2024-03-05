//
//  ResultView.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 5.03.2024.
//

import UIKit

class ResultView: UIView {
    
    private let headerLbl: UILabel = {
        LabelFactory.build(text: "Total p/person", font: ThemeFont.demibold(ofSize: 18))
    }()
    
    private let amountPerPersonLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        let text = NSMutableAttributedString(string: "$0", attributes: [
            .font: ThemeFont.bold(ofSize: 48)
        ])
        text.addAttributes([
            .font: ThemeFont.bold(ofSize: 24)], range: NSMakeRange(0, 1))
        label.attributedText = text
        return label
    }()
    
    private let horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.seperator
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLbl,
            amountPerPersonLbl,
            horizontalLineView,
            buildSpacerView(height: 0),
            hStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            AmountView(title: "Total Bill", textAlignment: .left),
            UIView(),
            AmountView(title: "Total Tip", textAlignment: .right)
        ])
        stackView.axis = .horizontal
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
        backgroundColor = .white
        addSubview(vStackView)
        vStackView.snp.makeConstraints{ make in
            make.top.equalTo(snp.top).offset(24)
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.bottom.equalTo(snp.bottom).offset(-24)
        }
        horizontalLineView.snp.makeConstraints{ make in
            make.height.equalTo(2)            
        }
        addShadow(offset: CGSize(width: 0, height: 3), color: .black, radius: 12.0, opacity: 0.1)
    }
    
    private func buildSpacerView(height: CGFloat) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
}
