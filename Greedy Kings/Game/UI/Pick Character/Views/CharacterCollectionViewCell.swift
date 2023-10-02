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
           characterImageView.image = character.avatar
           nameLabel.text = character.name
       }
}
