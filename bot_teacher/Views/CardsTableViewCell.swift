//
//  CardsTableViewCell.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/5.
//

import UIKit
import SnapKit

protocol CardsTableViewCellDelegate: AnyObject {
    func didTapButton(with teacher: Teacher)
}

class CardsTableViewCell: UITableViewCell {

    static let cellId = "CardsTableViewCell"
    
    weak var delegate: CardsTableViewCellDelegate?
    
    private var cellTeacher = initTeacher()
    
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
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    @IBAction func didTapButton() {
        delegate!.didTapButton(with: cellTeacher)
    }
          
    
    // MARK: -LifeCycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configure(with item: Teacher) {
        
        cellTeacher = item
        
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
        
        // image
        teacherImgView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.left.equalTo(containerVw.snp.left).offset(20)
            make.top.equalTo(containerVw.snp.top).offset(20)
            
        }
        
        // name
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(teacherImgView.snp.top)
            make.left.equalTo(teacherImgView.snp.right).offset(5)
        }
        
        // info
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalTo(teacherImgView.snp.right).offset(5)
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-20)
        }
        
        // button
        playButton.snp.makeConstraints { make in
            make.top.equalTo(teacherImgView.snp.bottom).offset(100)
            make.left.equalToSuperview().offset(30)
        }
        
        
        nameLabel.text = item.name
        infoLabel.text = item.info
        teacherImgView.image = UIImage(named: item.name)
        
    
    }
    
    
    
}
