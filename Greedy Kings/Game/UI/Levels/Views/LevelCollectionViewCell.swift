//
//  LevelCollectionViewCell.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 15.10.23.
//

import UIKit

class LevelCollectionViewCell: UICollectionViewCell {
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
    
    var avatarImageView: UIImageView? // To reuse the avatar image view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        // Configure the subviews
        addSubview(levelImageView)
        addSubview(nameLabel)
        
        levelImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            levelImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            levelImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            levelImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            levelImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5)
        ])
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with level: LevelsData) {
        nameLabel.text = level.name
        
        // Load the "cellFrame" image as the background frame
        if let cellFrameImage = UIImage(named: "cellFrame") {
            let cellFrameImageView = UIImageView(image: cellFrameImage)
            
            // Set content mode (choose an appropriate one for your design)
            cellFrameImageView.contentMode = .scaleToFill
            
            // Add the cellFrame image as a background, and send it to the back.
            self.insertSubview(cellFrameImageView, at: 0)
            
            cellFrameImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                cellFrameImageView.topAnchor.constraint(equalTo: self.topAnchor),
                cellFrameImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                cellFrameImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                cellFrameImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5)
            ])
        }
        
        // Remove the previously added avatar image view if it exists
        if let existingAvatarImageView = avatarImageView {
            existingAvatarImageView.removeFromSuperview()
        }
        
        // Load the avatar image based on level.iconID
        if let avatarImage = UIImage(named: level.iconID) {
            avatarImageView = UIImageView(image: avatarImage)
            avatarImageView?.contentMode = .scaleAspectFit
            
            // Add the avatar image as an overlay
            if let avatarImageView = avatarImageView {
                addSubview(avatarImageView)
                avatarImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                    avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                    avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                    avatarImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -20)
                ])
            }
        }
    }
}
