//
//  CharacterCollectionViewCell.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 27.09.23.
//

import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {
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
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            characterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            characterImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5),
            
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        if let cellFrameImage = UIImage(named: "cellFrame") {
            let cellFrameImageView = UIImageView(image: cellFrameImage)
            cellFrameImageView.contentMode = .scaleAspectFit
            
            self.contentView.addSubview(cellFrameImageView)
            cellFrameImageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                cellFrameImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                cellFrameImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                cellFrameImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                cellFrameImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5)])
            
            if let avatarImage = UIImage(named: character.avatarID) {
                let avatarImageView = UIImageView(image: avatarImage)
                avatarImageView.contentMode = .scaleAspectFit
                
                self.contentView.addSubview(avatarImageView)
                avatarImageView.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    avatarImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
                    avatarImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
                    avatarImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
                    avatarImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -15)])
            }
        }
    }
}
