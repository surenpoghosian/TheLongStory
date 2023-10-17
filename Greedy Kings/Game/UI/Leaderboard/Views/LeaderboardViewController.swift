//
//  LeaderboardViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 24.09.23.
//

import UIKit

final class LeaderboardViewController: UIViewController {
    private let tableView = UITableView()
    private var leaderboardLabel = UILabel()
    private var leaderboardData: [LeaderboardItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLeaderboardLabel(hintText: "LEADERBOARD")
        setupLeaderboardTableView()
    }
    
    private func setupUI(){
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    private func setupLeaderboardTableView() {
        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: "LeaderboardCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: leaderboardLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        leaderboardData = [
            LeaderboardItem(playerName: "John Doe", wins: 10, photoName: "1"),
            LeaderboardItem(playerName: "Jane Smith", wins: 8, photoName: "2"),
            LeaderboardItem(playerName: "Alice Johnson", wins: 7, photoName: "3")]
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupLeaderboardLabel(hintText: String) {
        leaderboardLabel = UILabel()
        leaderboardLabel.text = hintText.uppercased()
        leaderboardLabel.font = UIFont(name: "Futura-Bold", size: 40.0)
        leaderboardLabel.alpha = 0.7
        leaderboardLabel.textAlignment = .center
        leaderboardLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leaderboardLabel)
        
        NSLayoutConstraint.activate([
            leaderboardLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            leaderboardLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 150),
            leaderboardLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -150)
        ])
    }
}

extension LeaderboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        let leaderboardItem = leaderboardData[indexPath.row]
        
        cell.placeLabel.text = "\(indexPath.row + 1)"
        cell.playerNameLabel.text = leaderboardItem.playerName
        cell.winsLabel.text = "\(leaderboardItem.wins)"
        cell.playerPhotoImageView.image = UIImage(named: leaderboardItem.photoName)
        return cell
    }
}

extension LeaderboardViewController: UITableViewDelegate {

}

struct LeaderboardItem {
    var playerName: String
    var wins: Int
    var photoName: String
}

