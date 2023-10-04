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
    private var gameScene: UIView!
    private var physicsManager: PhysicsManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GameSceneViewModel()
        initializeGameScene()
        buildLevel(level: 1)
    }
        
    func initializeGameScene(){
        gameScene = UIView()
        gameScene.frame = view.bounds
    }
    
    
    func buildLevel(level: Int){
        levelBuilder = LevelBuilder(level: level)
        self.gameScene = levelBuilder.buildLevel(gameScene: gameScene)
        self.view.addSubview(self.gameScene)
        physicsManager = PhysicsManager(parentView: self.gameScene)
        physicsManager.shotFromLeft(item: gameScene.subviews[6])
    }
    
    
    
        
}
