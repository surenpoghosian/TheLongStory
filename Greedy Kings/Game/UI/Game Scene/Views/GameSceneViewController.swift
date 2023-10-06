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
        levelBuilder.initializePhysicsBehavior(parentView: self.gameScene)
        
        
//        ------------------TEST OF SHOT AND UPDATEAMMOLOCATION FUNCTIONS------------------
//        let leftAmmo = self.gameScene.subviews[6]
//        let rightAmmo = self.gameScene.subviews[7]
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
//        self.levelBuilder.physicsManager.shot(item: leftAmmo, velocityX: 100, velocityY: 130, toSide: .right)
//        })
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
//            self.levelBuilder.physicsManager.shot(item: rightAmmo, velocityX: 100, velocityY: 150, toSide: .left)
//        })
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: {
//            self.levelBuilder.updateAmmoLocation(locationOnScreen: .left, ammoView: leftAmmo)
//            self.levelBuilder.updateAmmoLocation(locationOnScreen: .right, ammoView: rightAmmo)
//        })
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 7, execute: {
//            self.levelBuilder.physicsManager.shot(item: leftAmmo, velocityX: 100, velocityY: 150, toSide: .right)
//        })
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 9, execute: {
//            self.levelBuilder.physicsManager.shot(item: rightAmmo, velocityX: 100, velocityY: 150, toSide: .left)
//        })
    }
}


