//
//  LoginReusableView.swift
//  SeSAC Study
//
//  Created by HeecheolYoon on 2022/11/09.
//

import UIKit
import SnapKit

class LoginReusableView: BaseView {
    
    var message = ""
    var detailMessage = ""
    var buttonTitle = ""
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = message
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var detailMessageLabel: UILabel = {
        let label = UILabel()
        label.text = detailMessage
        label.textColor = .graySeven
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = buttonTitle
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .brandGreen
        configuration.cornerStyle = .medium
        
        button.configuration = configuration
        return button
    }()
    
    init(message: String, detailMessage: String, buttonTitle: String) {
        self.message = message
        self.detailMessage = detailMessage
        self.buttonTitle = buttonTitle
        super.init(frame: CGRect.zero)
    }
    
    override func configure() {
        super.configure()
        
        [messageLabel, detailMessageLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [stackView, doneButton].forEach {
            addSubview($0)
        }
    }
    
    override func setUpConstraints() {
        super.setUpConstraints()
        
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        detailMessageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(160)
            make.horizontalEdges.equalToSuperview().inset(73.5)
            make.height.equalTo(64)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(400)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}