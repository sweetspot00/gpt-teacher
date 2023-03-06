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
    private var chatTeacher = initTeacher()
    @IBOutlet weak var theContainer: UIView!
    let chatView = UIHostingController(rootView: ChatView())
    // MARK: -UI constant
    private lazy var chatTableVw: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = chatTeacher.color
        tv.estimatedRowHeight = 100
        tv.separatorStyle = .none
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tv.register(SenderViewCell.self, forCellReuseIdentifier: SenderViewCell.cellId)
        tv.register(ResponseViewCell.self, forCellReuseIdentifier: ResponseViewCell.cellId)
        return tv
    }()
    
    // MARK: - speech to text
    var recognizer = Recognizer()
    @StateObject var speechRecognizer = SpeechRecognizer()
    
    let stopReceiver: Void = NotificationCenter.default.addObserver(ChatViewController.self,
                                                          selector: #selector(stopRecognizer),
                                                          name: Notification.Name.recognizerStop,
                                                          object: nil)
    
    let startReceiver: Void = NotificationCenter.default.addObserver(ChatViewController.self,
                                                                    selector: #selector(startRecognizer),
                                                                    name: Notification.Name.recognizerStart,
                                                                    object: nil)
    
    @objc func stopRecognizer(_ notification: Notification) {
        recognizer.stopListening = true
        self.speechRecognizer.stopTranscribing()
    }
    
    @objc func startRecognizer(_ notification: Notification) {
        recognizer.stopListening = false
        self.speechRecognizer.reset()
        self.speechRecognizer.transcribe()
    }
    
    // MARK: - convert gpt response to speech
    let synthesizer = AVSpeechSynthesizer()

    
    // MARK: - LifeCycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // start listening when chat view loaded
        speechRecognizer.reset()
        speechRecognizer.transcribe()
        
        
    }
    
    public func setup(with teacher: Teacher) {
        chatTeacher = teacher
        APICaller.shared.setup()
    }

    

}

private extension ChatViewController {

    func setupViews() {
        addChild(chatView)
        view.addSubview(chatView.view)
        setChatViewConstraints()
    }
    
    func setChatViewConstraints() {
        chatView.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let chatMessage = messages[indexPath.row]

        switch chatMessage.messageType {
            case .Sender:
                let cell = tableView.dequeueReusableCell(withIdentifier: SenderViewCell.cellId, for: indexPath) as! SenderViewCell
                cell.configure(with: chatTeacher)
                return cell
            case .Response:
                let cell = tableView.dequeueReusableCell(withIdentifier: ResponseViewCell.cellId, for: indexPath) as! ResponseViewCell
                cell.configure(with: chatTeacher)
                return cell
        }
        
    }
    

}

extension Notification.Name {
    static var recognizerStop: Notification.Name {
          return .init(rawValue: "recognier.status.stop") }
    static var recognizerStart: Notification.Name {
          return .init(rawValue: "recognier.status.start") }

}
