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
    @IBOutlet weak var backButton: UIButton!
    private var leaderboardData: [LeaderboardItem] = []
    private let medalEmojis = ["🥇", "🥈", "🥉"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBackButton()
        setupLeaderboardData()
        setupLeaderboardLabel(hintText: "LEADERBOARD")
        setupLeaderboardTableView()
    }
    
    // hide default navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // setup leaderboard UI
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    // setup leaderboard data for UITableView
    private func setupLeaderboardData() {
        leaderboardData = [
            LeaderboardItem(playerName: "John Doe", wins: 10, photoName: "1"),
            LeaderboardItem(playerName: "Jane Smith", wins: 8, photoName: "2"),
            LeaderboardItem(playerName: "Alice Johnson", wins: 7, photoName: "3"),
            LeaderboardItem(playerName: "Alice Johnson", wins: 7, photoName: "4"),
            LeaderboardItem(playerName: "Alice Johnson", wins: 7, photoName: "5"),
            LeaderboardItem(playerName: "Alice Johnson", wins: 7, photoName: "6")]
    }
    
    // setup custom back button for navigation
    private func setupBackButton() {
        backButton.setBackgroundImage(UIImage(named: "leftArrowIcon"), for: .normal)
        backButton.addAction(UIAction(handler: {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        view.bringSubviewToFront(backButton)
    }
    
    // setup leaderboard UITableView
    private func setupLeaderboardTableView() {
        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: "LeaderboardCell")
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: leaderboardLabel.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // set leaderboard header label
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
        
        // change the place labels for the fisrt three places
        if indexPath.row < 3 {
            cell.placeLabel.text = medalEmojis[indexPath.row]
            cell.placeLabel.font = UIFont.systemFont(ofSize: 16)
            cell.placeLabel.textColor = .white
        } else {
            cell.placeLabel.text = "\(indexPath.row + 1)"
            cell.placeLabel.font = UIFont.systemFont(ofSize: 16)
            cell.placeLabel.textColor = .white
        }
        
        cell.playerNameLabel.text = leaderboardItem.playerName
        cell.winsLabel.text = "\(leaderboardItem.wins)"
        cell.playerPhotoImageView.image = UIImage(named: leaderboardItem.photoName)
        cell.backgroundColor = UIColor(named: "backgroundColor")
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
