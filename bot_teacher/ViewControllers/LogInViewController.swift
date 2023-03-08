//
//  LogInViewController.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/5.
//

import UIKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setup() {
        
        self.title = "Login/Sign In"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = .white
        
        self.view.addSubview(LoginButton)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(opaiAPIKeyTextField)
        
        LoginButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(44)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(44)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            
            
        }

        opaiAPIKeyTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(44)
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
            
        }
        
    
        
        
    }
    
    private func setPlaceHolderValue(with value: String, _ textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string: value, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black.withAlphaComponent(0.5)])
    }
    
    private func configTextField(_ textField: UITextField) {
        textField.backgroundColor = .black.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 6
    }
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        setPlaceHolderValue(with: "Your Name", textField)
        configTextField(textField)
        return textField
    }()
    
    private lazy var opaiAPIKeyTextField: UITextField = {
        let textField = UITextField()
        setPlaceHolderValue(with: "Your OpenAI API Key", textField)
        configTextField(textField)
        return textField
    }()
    
    
    private lazy var LoginButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(openTeachersList), for: .touchUpInside)
        return button
        
    }()
    
    @objc func openTeachersList() {
        // MARK: pass key and username
    
        if let username = usernameTextField.text, let key = opaiAPIKeyTextField.text {
            let vc = TeacherCardsViewController()
            vc.key = key
            vc.userName = username
            self.navigationController?.pushViewController(vc, animated: true)
        }
        

    }

}
