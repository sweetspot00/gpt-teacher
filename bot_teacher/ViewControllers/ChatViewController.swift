//
//  ChatViewController.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/5.
//

import UIKit
import AVKit
import AVFoundation
import SwiftUI
import SnapKit

struct Recognizer {
    
    var waitingTime = 60
    var stopListening = false
    
}


class ChatViewController: UIViewController {
    
    // get chat info
    var key = ""
    var userName = ""
    private var chatTeacherName = ""
    var opaiCaller: APICaller = APICaller()
    
    // MARK: - LifeCycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    public func setup(teacherName: String, username: String) {
        opaiCaller.setup(with: OPENAI_KEY)
        chatTeacherName = teacherName
        self.userName = username
    }
    

    

}

private extension ChatViewController {

//    func setupViews() {
//        let chatView = UIHostingController(rootView: ChatView(chatTeacherName: chatTeacherName, userName: self.userName, client: opaiCaller.getClient()))
//        addChild(chatView)
//        view.addSubview(chatView.view)
//        chatView.view.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
//    }
//
}

