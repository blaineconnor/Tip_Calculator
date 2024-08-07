//
//  LogoView.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 5.03.2024.
//

import UIKit
import Combine

class LogoView: UIView{
    
    private let imageView: UIImageView = {
        let view = UIImageView(image: .init(named: "tipCalc"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(
            string: "TIP",
            attributes: [.font: ThemeFont.demibold(ofSize: 16)])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 24)], range: NSMakeRange(0, 3))
        label.attributedText = text
        return label
    }()
    
    private let bottomLabel: UILabel = {
        LabelFactory.build(text: "Calculator", 
                           font: ThemeFont.demibold(ofSize: 20),
                           textAlignment: .left)
    }()
    
    private lazy var vStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews:   [
        topLabel,
        bottomLabel
        ])
        view.axis = .vertical
        view.spacing = -4
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews:   [
        imageView,
        vStackView
        ])
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .center
        return view
    }()
    
    lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = { [weak self] in
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        self?.addGestureRecognizer(tapGesture)
         return tapGesture.tapPublisher.flatMap{ [weak self] _ in
            Just(())
         }.eraseToAnyPublisher()
    }()
    
    
    init() {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
    addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width)
            
        }
    }
}
