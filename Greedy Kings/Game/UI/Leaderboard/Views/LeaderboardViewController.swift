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
    private var storageManager: StorageManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageManager = StorageManager()
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
    
    
    private func checkLeaderboardDataExistence(){
        if storageManager.get(key: "leaderboard", storageType: .userdefaults) == nil {
            if let data = storageManager.get(key: "characters", storageType: .userdefaults) as? Data {
                let decoder = JSONDecoder()
                if let characters = try? decoder.decode([Character].self, from: data) {

                    let leaderboardData = characters.map { character in
                        LeaderboardItem(playerName: character.name, wins: 0, photoName: character.avatarID)
                    }
                    
                    let encoder = JSONEncoder()
                    if let encodedData = try? encoder.encode(leaderboardData) {
                        storageManager.set(key: "leaderboard", value: encodedData, storageType: .userdefaults)
                    }

                }
            }

        }
    }

    
    // setup leaderboard UI
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    // setup leaderboard data for UITableView
    private func setupLeaderboardData() {
        checkLeaderboardDataExistence()
        
        if let data = storageManager.get(key: "leaderboard", storageType: .userdefaults) as? Data {
            let decoder = JSONDecoder()
            if let leaderboard = try? decoder.decode([LeaderboardItem].self, from: data) {
                let sortedLeaderboard = leaderboard.sorted { (item1, item2) in
                    if item1.wins == 0 && item2.wins == 0 {
                        return item1.playerName < item2.playerName
                    } else {
                        return item1.wins > item2.wins
                    }
                }
                
                leaderboardData = sortedLeaderboard
            }
        }
        
    }
    
    // setup custom back button for navigation
    private func setupBackButton() {
        backButton.setBackgroundImage(UIImage(named: "leftArrowIcon"), for: .normal)
        backButton.addAction(UIAction(handler: {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        backButton.accessibilityIdentifier = "leaderboardPageBackButton"
        
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
        leaderboardLabel.textColor = .white
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as! LeaderboardCell
        let leaderboardItem = leaderboardData[indexPath.row]
        cell.selectionStyle = .none
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
        cell.playerNameLabel.textColor = .white

        cell.winsLabel.text = "\(leaderboardItem.wins)"
        cell.winsLabel.textColor = .white
        
        cell.playerPhotoImageView.image = UIImage(named: leaderboardItem.photoName)
        cell.backgroundColor = UIColor(named: "backgroundColor")
        return cell
    }
}

extension LeaderboardViewController: UITableViewDelegate {
    
}

struct LeaderboardItem: Codable {
    var playerName: String
    var wins: Int
    var photoName: String
}
