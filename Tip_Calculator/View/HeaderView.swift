//
//  HeaderView.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 6.03.2024.
//

import UIKit


class HeaderView: UIView {
    
    private let topLbl: UILabel = {
        LabelFactory.build(text: nil, font: ThemeFont.bold(ofSize: 18))
    }()
    
    private let bottomLbl: UILabel = {
        LabelFactory.build(text: nil, font: ThemeFont.regular(ofSize: 16))
    }()
    
    private let topSpacerView = UIView()
    private let bottomSpacerView = UIView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            
            topSpacerView,
            topLbl,
            bottomLbl,
            bottomSpacerView
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = -4
        return stackView
    }()
    
    
    init(){
        super.init(frame: .zero)
        layout()
    }
    
    private func layout() {
       addSubview(stackView)
        stackView.snp.makeConstraints{make in
            make.edges.equalToSuperview()
        }
        topSpacerView.snp.makeConstraints{make in
            make.height.equalTo(bottomSpacerView)
        }
    }
    
    func configure(topText: String, bottomText: String){
        topLbl.text = topText
        bottomLbl.text = bottomText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
