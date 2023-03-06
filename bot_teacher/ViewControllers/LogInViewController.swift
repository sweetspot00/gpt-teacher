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
        
        LoginButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        
    }
    
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
        let vc = TeacherCardsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
