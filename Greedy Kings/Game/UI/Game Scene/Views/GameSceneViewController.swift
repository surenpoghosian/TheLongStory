//
//  GameSceneViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 24.09.23.
//

import UIKit

final class GameSceneViewController: UIViewController {

    weak var delegate: GameDataDelegate?
    private var viewModel: GameSceneViewModel!
    private var levelBuilder: LevelBuilder!

    // create scene view
    private var gameScene: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GameSceneViewModel()
        initializeGameScene()
        buildLevel(level: 1)
    }
        
    func initializeGameScene(){
        gameScene = UIView()
    }
    
    func buildLevel(level: Int){
        levelBuilder = LevelBuilder(level: level)
        gameScene = levelBuilder.buildLevel(gameScene: gameScene)
        self.view.addSubview(gameScene)
    }
    
    
//    create level UI building function and call in it LevelBuilder(level: )
    
}
