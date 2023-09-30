//
//  GameSceneViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 24.09.23.
//

import UIKit

final class GameSceneViewController: UIViewController {

    private var viewModel: GameSceneViewModel!
    weak var delegate: GameDataDelegate?
    private var levelBuilder: LevelBuilder!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GameSceneViewModel()
        setupLevelBuilder()
    }
        
    func setupLevelBuilder(){
        levelBuilder = LevelBuilder(level: 1)
        print("setupLevelBuilder")
    }
}
