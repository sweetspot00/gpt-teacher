//
//  ResponseViewCell.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/6.
//

import UIKit
import SnapKit

class ResponseViewCell: UITableViewCell {
    
    
    /*  |
        |pic messageBox
        |name
     */

    static let cellId = "ResponseViewCell"
    
    private lazy var messageBox: UIView = {
        let vw = UIView()
        vw.layer.cornerRadius = 8
        return vw
    }()
    
    // subscribe to GPT response
    private lazy var messages: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .white
        label.lineBreakMode = NSLineBreakMode.byCharWrapping
        label.numberOfLines = 0
        return label
    }()

    private lazy var teacherImgView: UIImageView = {
       let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configure(with item: Teacher) {
        self.contentView.backgroundColor = .green
        
//        self.contentView.addSubview(messageBox)
//        self.contentView.addSubview(teacherImgView)
//
//        // image
//        teacherImgView.snp.makeConstraints { make in
//            make.width.height.equalTo(60)
//            make.left.equalToSuperview().offset(8)
//        }
//
//
//        messageBox.snp.makeConstraints { make in
//            make.top.equalTo(teacherImgView.snp.top)
//            make.left.equalTo(teacherImgView.snp.right).offset(5)
//            make.bottom.equalToSuperview().offset(-10)
//            make.right.equalToSuperview().offset(-50)
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
//        teacherImgView.image = UIImage(named: item.name)
//
    
    }
}
