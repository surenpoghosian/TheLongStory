//
//  LevelCollectionViewCell.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 15.10.23.
//

import UIKit

class LevelCollectionViewCell: UICollectionViewCell {
    private let screenSize = UIScreen.main.bounds
    private let levelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        addSubview(levelImageView)
//        addSubview(nameLabel)
    
        levelImageView.translatesAutoresizingMaskIntoConstraints = false
//        levelImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
//        levelImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
//        levelImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
//                
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with level: LevelsData) {
        nameLabel.text = level.name
        print(level)

        if let cellFrameImage = UIImage(named: "cellFrame") {
            let cellFrameImageView = UIImageView(image: cellFrameImage)
            cellFrameImageView.contentMode = .scaleAspectFit
            
            self.contentView.addSubview(cellFrameImageView)
            cellFrameImageView.translatesAutoresizingMaskIntoConstraints = false
            let cellFrameWidth = contentView.frame.width
//            CGFloat(screenSize.width / 4 - 20)
            cellFrameImageView.widthAnchor.constraint(equalToConstant: cellFrameWidth ).isActive = true
            cellFrameImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
//            cellFrameImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
            
            if let iconImage = UIImage(named: level.iconID) {
                let iconImageView = UIImageView(image: iconImage)
                self.contentView.addSubview(iconImageView)
                iconImageView.contentMode = .scaleAspectFit
                iconImageView.translatesAutoresizingMaskIntoConstraints = false
                iconImageView.widthAnchor.constraint(equalToConstant: cellFrameWidth * 0.5 ).isActive = true
                iconImageView.centerXAnchor.constraint(equalTo: cellFrameImageView.centerXAnchor).isActive = true
                iconImageView.centerYAnchor.constraint(equalTo: cellFrameImageView.centerYAnchor).isActive = true
                                
            }
        }
    }}

