//
//  CharacterCollectionViewCell.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 27.09.23.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    let characterImageView: UIImageView = {
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
           
           addSubview(characterImageView)
           addSubview(nameLabel)
           
           characterImageView.translatesAutoresizingMaskIntoConstraints = false
           characterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
           characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
           characterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
           characterImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5).isActive = true

           nameLabel.translatesAutoresizingMaskIntoConstraints = false
           nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
           nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
           nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
    func configure(with character: Character) {
        nameLabel.text = character.name

        // Load the "cellFrame" image as the background frame
        if let cellFrameImage = UIImage(named: "cellFrame") {
            let cellFrameImageView = UIImageView(image: cellFrameImage)
            cellFrameImageView.contentMode = .scaleAspectFit

            // Add the cellFrame image as a background
            self.contentView.addSubview(cellFrameImageView)
            cellFrameImageView.translatesAutoresizingMaskIntoConstraints = false
            cellFrameImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
            cellFrameImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
            cellFrameImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
            cellFrameImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5).isActive = true

            // Assuming you have avatar images named "1.png", "2.png", ..., "10.png"
            if let avatarImage = UIImage(named: character.avatarID) {
                let avatarImageView = UIImageView(image: avatarImage)
                avatarImageView.contentMode = .scaleAspectFit

                // Add the avatar image as an overlay
                self.contentView.addSubview(avatarImageView)
                avatarImageView.translatesAutoresizingMaskIntoConstraints = false
                avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
                avatarImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5).isActive = true
                avatarImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5).isActive = true
                avatarImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -10).isActive = true
            }
        }
    }}
