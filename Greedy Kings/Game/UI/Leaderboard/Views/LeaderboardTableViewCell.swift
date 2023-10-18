//
//  TableViewCell.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 17.10.23.
//

import UIKit

final class LeaderboardCell: UITableViewCell {
    let placeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playerPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let playerNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let winsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(placeLabel)
        contentView.addSubview(playerPhotoImageView)
        contentView.addSubview(playerNameLabel)
        contentView.addSubview(winsLabel)

        NSLayoutConstraint.activate([
            placeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            placeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            playerPhotoImageView.leadingAnchor.constraint(equalTo: placeLabel.trailingAnchor, constant: 16),
            playerPhotoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playerPhotoImageView.widthAnchor.constraint(equalToConstant: 40),
            playerPhotoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            playerNameLabel.leadingAnchor.constraint(equalTo: playerPhotoImageView.trailingAnchor, constant: 16),
            playerNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            winsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            winsLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
