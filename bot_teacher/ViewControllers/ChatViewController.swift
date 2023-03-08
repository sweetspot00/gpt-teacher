//
//  ChatViewController.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/5.
//

import UIKit
import MessageKit
import AVKit
import AVFoundation
import SwiftUI
import Async
import SnapKit

struct Recognizer {
    
    var waitingTime = 60
    var stopListening = false
    
}


class ChatViewController: UIViewController {
    
    // get chat info
    var key = ""
    var userName = ""
    private var chatTeacher = initTeacher()
    var opaiCaller: APICaller = APICaller()
    
    // MARK: - LifeCycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    public func setup(teacher: Teacher, opaiKey: String, name: String) {
        chatTeacher = teacher
        opaiCaller.setup(with: opaiKey)
        self.key = opaiKey
        self.userName = name
    }

    

}

private extension ChatViewController {

    func setupViews() {
        let chatView = UIHostingController(rootView: ChatView(chatTeacher: chatTeacher,userName: self.userName, client: opaiCaller.getClient()))
        addChild(chatView)
        view.addSubview(chatView.view)
        chatView.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}

