//
//  BillInputView.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 5.03.2024.
//

import UIKit

class BillInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Enter", bottomText: "your bill")
        return view
    }()
    
    private let textFieldContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(radius: 8.0)
        return view
    }()
    
    private let currencyDenominationLabel: UILabel = {
        let label = LabelFactory.build(text: "$", font: ThemeFont.bold(ofSize: 24))
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = ThemeFont.demibold(ofSize: 28)
        tf.keyboardType = .decimalPad
        tf.setContentHuggingPriority(.defaultLow, for: .horizontal)
        tf.tintColor = ThemeColor.text
        tf.textColor = ThemeColor.text
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36))
        
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnTapped))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneBtn
        ]
        toolbar.isUserInteractionEnabled = true
        tf.inputAccessoryView = toolbar
        return tf
    }()
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [headerView, textFieldContainerView].forEach(addSubview(_:))
        
        headerView.snp.makeConstraints{make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(textFieldContainerView.snp.centerY)
            make.width.equalTo(68)
            make.trailing.equalTo(textFieldContainerView.snp.leading).offset(-24)
        }
        
        textFieldContainerView.snp.makeConstraints{make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        textFieldContainerView.addSubview(currencyDenominationLabel)
        textFieldContainerView.addSubview(textField)
        
        currencyDenominationLabel.snp.makeConstraints{make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints{make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(currencyDenominationLabel.snp.trailing).offset(16)
            make.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
        }
    }
    
    @objc private func doneBtnTapped() {
        textField.endEditing(true)
    }
}

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
