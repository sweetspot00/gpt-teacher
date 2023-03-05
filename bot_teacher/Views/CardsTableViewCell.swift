//
//  CardsTableViewCell.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/5.
//

import UIKit
import SnapKit

class CardsTableViewCell: UITableViewCell {

    static let cellId = "CardsTableViewCell"
    
    // MARK: - UI
    
    private lazy var containerVw: UIView = {
        let vw = UIView()
        vw.layer.cornerRadius = 8
        return vw
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
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
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32)), for: .normal)
        return button
    }()
    
    // MARK: -LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
//        containerVw.layer.cornerRadius = 10
        
    }
    
    func configure(with item: Teacher) {
        
        self.contentView.addSubview(containerVw)
        
        containerVw.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.right.equalToSuperview().offset(-8)
        }
        
        
        self.containerVw.addSubview(playButton)
        self.containerVw.addSubview(teacherImgView)
        self.containerVw.addSubview(nameLabel)
        self.containerVw.addSubview(infoLabel)
        
        self.containerVw.backgroundColor = item.color
        
        teacherImgView.snp.makeConstraints { make in
            
            make.width.height.equalTo(60)
            make.left.equalTo(containerVw.snp.left).offset(20)
            make.top.equalTo(containerVw.snp.top).offset(20)
            
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(teacherImgView.snp.top)
            make.left.equalTo(teacherImgView.snp.right).offset(5)
        
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(teacherImgView.snp.right).offset(5)
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-20)
        }
        
        playButton.snp.makeConstraints { make in
            make.top.equalTo(teacherImgView.snp.bottom).offset(100)
            make.left.equalToSuperview().offset(30)
        }
        
        
        nameLabel.text = item.name
        infoLabel.text = item.info
        teacherImgView.image = UIImage(named: item.name)
        
        
//        contentStackVw.addArrangedSubview(nameLabel)
//        contentStackVw.addArrangedSubview(infoLabel)

        
        
//        NSLayoutConstraint.activate([
//
//            containerVw.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
//            containerVw.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
//            containerVw.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
//            containerVw.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
//
//            teacherImgView.heightAnchor.constraint(equalToConstant: 50),
//            teacherImgView.widthAnchor.constraint(equalToConstant: 50),
//            teacherImgView.topAnchor.constraint(equalTo: contentStackVw.topAnchor),
//            teacherImgView.leadingAnchor.constraint(equalTo: containerVw.leadingAnchor, constant: 8),
//
//
//            // contentStackView
//            contentStackVw.topAnchor.constraint(equalTo: self.containerVw.topAnchor, constant: 16),
//            contentStackVw.bottomAnchor.constraint(equalTo: self.containerVw.bottomAnchor, constant: -16),
//            contentStackVw.leadingAnchor.constraint(equalTo: self.containerVw.leadingAnchor, constant: 8),
//            contentStackVw.trailingAnchor.constraint(equalTo: self.containerVw.trailingAnchor, constant: -8),
//
//            // button
//            playButton.heightAnchor.constraint(equalToConstant: 44),
//            playButton.widthAnchor.constraint(equalToConstant: 44),
//            playButton.trailingAnchor.constraint(equalTo: containerVw.trailingAnchor, constant: -8),
//            playButton.centerYAnchor.constraint(equalTo: containerVw.centerYAnchor)
//
//
//        ])
    }
    
    
    
}
