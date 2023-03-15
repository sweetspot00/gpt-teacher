//
//  CardsTableViewCell.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/5.
//

import UIKit
import SnapKit

protocol CardsTableViewCellDelegate: AnyObject {
    func didTapButton(teacher: Teacher)
}

class CardsTableViewCell: UITableViewCell {

    static let cellId = "CardsTableViewCell"
    
    weak var delegate: CardsTableViewCellDelegate?
    
    private var cellTeacher = initTeacher()

    // MARK: - UI
    
    private lazy var containerVw: UIView = {
        let vw = UIView()
        vw.layer.cornerRadius = 8
//        vw.layer.shadowColor = UIColor.black.cgColor
//        vw.layer.shadowOffset = CGSizeMake(5,0.5)
//        vw.layer.shadowOpacity = 0.3
//        vw.layer.shadowRadius = 1.0
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
        imgView.layer.shadowOffset = CGSizeMake(5,0.5)
        imgView.layer.shadowColor = UIColor.black.cgColor
        
        return imgView
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    @IBAction func didTapButton() {
        delegate!.didTapButton(teacher: cellTeacher)
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
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-8)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(300)
            make.height.equalTo(300)
        }
        
        
        self.containerVw.addSubview(playButton)
        self.containerVw.addSubview(teacherImgView)
        
        // image
        teacherImgView.snp.makeConstraints { make in
            make.right.equalTo(containerVw.snp.right)
            make.left.equalTo(containerVw.snp.left)
            make.top.equalTo(containerVw.snp.top)
            make.bottom.equalTo(containerVw.snp.bottom)
            
        }
        
        // button
        playButton.snp.makeConstraints { make in
            make.top.equalTo(teacherImgView.snp.top)
            make.left.equalTo(teacherImgView.snp.left)
            make.width.equalTo(teacherImgView.snp.width)
            make.height.equalTo(teacherImgView.snp.height)
            make.center.equalTo(teacherImgView.center)
        }
        
        
        nameLabel.text = item.name
        teacherImgView.image = UIImage(named: item.name)?.withRoundedCorners(radius: 30)
        
    
    }
    
    
    
}

extension UIImage {
       // image with rounded corners
       public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
           let maxRadius = min(size.width, size.height) / 2
           let cornerRadius: CGFloat
           if let radius = radius, radius > 0 && radius <= maxRadius {
               cornerRadius = radius
           } else {
               cornerRadius = maxRadius
           }
           UIGraphicsBeginImageContextWithOptions(size, false, scale)
           let rect = CGRect(origin: .zero, size: size)
           UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
           draw(in: rect)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image
       }
   }
