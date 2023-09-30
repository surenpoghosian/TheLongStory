//
//  MainMenuViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 24.09.23.
//

import UIKit

final class MainMenuViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    
    private var viewModel: MainMenuViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainMenuViewModel()
        
        playButton.addAction(UIAction(handler: { [weak self]_ in
            self?.pushViewController(identifier: "GameSceneView", viewControllerType: GameSceneViewController.self)
        }), for: .touchUpInside)
        
        settingsButton.addAction(UIAction(handler: { [weak self]_ in
            self?.pushViewController(identifier: "SettingsView", viewControllerType: SettingsViewController.self)
        }), for: .touchUpInside)
        
        leaderboardButton.addAction(UIAction(handler: { [weak self]_ in
            self?.pushViewController(identifier: "LeaderboardView", viewControllerType: LeaderboardViewController.self)
        }), for: .touchUpInside)

    }
    
    func pushViewController<T: UIViewController>(identifier: String, viewControllerType: T.Type) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

protocol GameDataDelegate: AnyObject {
    func didResultSent()
}

extension MainMenuViewModel: GameDataDelegate {
    func didResultSent() {
        print("Data Recieved!")
    }
}
