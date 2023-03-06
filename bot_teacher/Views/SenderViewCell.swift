//
//  SenderViewCell.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/6.
//

import UIKit
import SnapKit

class SenderViewCell: UITableViewCell {
    /*         |
     messageBox|
             me|
     */

    static let cellId = "SenderViewCell"
    private lazy var messageBox: UIView = {
        let vw = UIView()
        vw.layer.cornerRadius = 8
        return vw
    }()
    
    // subscribe to user input speech
    private lazy var messages: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .white
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

    func configure(with item: Teacher) {
        
//        self.contentView.addSubview(messageBox)
//
//        messageBox.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(8)
//            make.left.equalToSuperview().offset(50)
//            make.bottom.equalToSuperview().offset(-10)
//            make.right.equalToSuperview().offset(-8)
//        }
//
//
//
//        self.messages.backgroundColor = item.color
//
//    
//        // info
//        messages.snp.makeConstraints { make in
//            make.top.equalTo(messageBox.snp.top).offset(5)
//            make.left.equalTo(messageBox.snp.left).offset(5)
//            make.bottom.equalTo(messageBox.snp.bottom).offset(-5)
//            make.right.equalTo(messageBox.snp.right).offset(-5)
//        }
//
//        messages.text = "some text"
        
    
    }
}
