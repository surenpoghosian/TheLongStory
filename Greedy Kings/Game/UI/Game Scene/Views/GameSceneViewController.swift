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
        viewModel.gameFinished = self.gameFinished
        
        
        initializeGameScene()
        buildLevel(level: 1)
    }
    
    func gameFinished() {
        print("gamefinished")
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
        
        self.levelBuilder.physicsManager.collisionBehavior.collisionDelegate = self



        
        
//        ------------------TEST OF SHOT AND UPDATEAMMOLOCATION FUNCTIONS------------------
        let leftAmmo = self.gameScene.subviews[6]

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            self.levelBuilder.physicsManager.shot(item: leftAmmo, velocityX: 100, velocityY: 130, toSide: .right)
        })

    }
}


extension GameSceneViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, with otherItem: UIDynamicItem, at point: CGPoint) {
        if let view = item as? UIView, let otherView = otherItem as? UIView {
            if otherView == self.gameScene.subviews[6] && view == self.gameScene.subviews[2] {
                print("Player1 HIT Player2")
                self.viewModel.onHit()
                self.gameScene.subviews[6].isHidden = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    
                    self.levelBuilder.updateAmmoLocation(locationOnScreen: .left, ammoView: self.gameScene.subviews[6])
                    self.gameScene.subviews[6].isHidden = false
                    self.levelBuilder.physicsManager.shot(item: self.gameScene.subviews[7], velocityX: 100, velocityY: 130, toSide: .left)
                })
            }

            if otherView == self.gameScene.subviews[7] && view == self.gameScene.subviews[1] {
                print("Player2 HIT Player1")
                self.viewModel.onHit()
                self.gameScene.subviews[7].isHidden = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    
                    self.levelBuilder.updateAmmoLocation(locationOnScreen: .right, ammoView: self.gameScene.subviews[7])
                    self.gameScene.subviews[7].isHidden = false
                    self.levelBuilder.physicsManager.shot(item: self.gameScene.subviews[6], velocityX: 100, velocityY: 130, toSide: .right)
                })
            }
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if let view = item as? UIView {
            self.viewModel.onMiss()
//            if view == self.gameScene.subviews[6] {
//                self.levelBuilder.updateAmmoLocation(locationOnScreen: .left, ammoView: self.gameScene.subviews[6])
//
//            } else if view == self.gameScene.subviews[7]{
//                self.levelBuilder.updateAmmoLocation(locationOnScreen: .right, ammoView: self.gameScene.subviews[7])
//
//            }
        }
        
    }
}




