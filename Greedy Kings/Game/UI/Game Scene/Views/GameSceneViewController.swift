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
    var viewanimator1: UIViewPropertyAnimator!
    var viewanimator1_2: UIViewPropertyAnimator!
    var viewanimator2: UIViewPropertyAnimator!
    var viewanimator2_2: UIViewPropertyAnimator!
    var isGameFinished: Bool = false
    
    override func viewWillDisappear(_ animated: Bool) {
        isGameFinished = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GameSceneViewModel()
        viewModel.gameFinished = self.gameFinished
        
        
        initializeGameScene()
        buildLevel(level: 1)
    }
    
    func gameFinished() {
        isGameFinished = true
        print("gamefinished")
    }
        
    func initializeGameScene(){
        gameScene = UIView()
        gameScene.frame = view.bounds
    }
    
    func startAnimation(for player: Player){
        let minRotationAngleDegrees: CGFloat = 25.0
        let maxRotationAngleDegrees: CGFloat = 80.0

        let minRotationAngleRadians = minRotationAngleDegrees.degreesToRadians
        let maxRotationAngleRadians = maxRotationAngleDegrees.degreesToRadians

        switch player {
        case .player1:

            viewanimator1 = UIViewPropertyAnimator(
                duration: 1.5,
                curve: .linear,
                animations: {
                    self.gameScene.subviews[4].transform = CGAffineTransform(rotationAngle: minRotationAngleRadians)
                }
            )

            viewanimator1.addCompletion { _ in
                self.viewanimator1_2 = UIViewPropertyAnimator(
                    duration: 1.5,
                    curve: .linear,
                    animations: {
                        self.gameScene.subviews[4].transform = CGAffineTransform(rotationAngle: maxRotationAngleRadians)
                    }
                )
                self.viewanimator1_2.addCompletion { _ in
                    self.startAnimation(for: .player1)
                }
                
                self.viewanimator1_2.startAnimation()
            }
        
            viewanimator1.startAnimation()
            
        case .player2:
            viewanimator2 = UIViewPropertyAnimator(
                duration: 1.5,
                curve: .linear,
                animations: {
                    self.gameScene.subviews[5].transform = CGAffineTransform(rotationAngle: -minRotationAngleRadians)
                }
            )

            viewanimator2.addCompletion { _ in
                self.viewanimator2_2 = UIViewPropertyAnimator(
                    duration: 1.5,
                    curve: .linear,
                    animations: {
                        self.gameScene.subviews[5].transform = CGAffineTransform(rotationAngle: -maxRotationAngleRadians)
                    }
                )
                self.viewanimator2_2.addCompletion { _ in
                    self.startAnimation(for: .player2)
                }
                
                self.viewanimator2_2.startAnimation()
            }
        
            viewanimator2.startAnimation()
        }
    }
    
    
    func stopAnimation(for player: Player){
        switch player{
        case .player1:
            self.viewanimator1.stopAnimation(true)
            if let _ = self.viewanimator1_2{
                self.viewanimator1_2.stopAnimation(true)
            }
        case .player2:
            self.viewanimator2.stopAnimation(true)
            if let _ = self.viewanimator2_2{
                self.viewanimator2_2.stopAnimation(true)
            }
        }
    }

    // Handle left tap gesture
    @objc func leftTapped() {
        
//        self.gameScene.subviews[7].isHidden = true
//        self.gameScene.subviews[4].transform = CGAffineTransform(rotationAngle:(CGFloat(90).degreesToRadians))
//
//        let rightWeapon = self.gameScene.subviews[5]
//        let rightAmmo = self.gameScene.subviews[7]
//
//        self.levelBuilder.physicsManager.removeGravityBehavior(from: rightAmmo)
//
//        self.levelBuilder.updateAmmoLocation(for: rightWeapon, ammo: rightAmmo)
//
//        self.stopAnimation(for: .player1)
//
//        let leftWeapon = self.gameScene.subviews[4]
//        let leftAmmo = self.gameScene.subviews[6]
//
//        self.levelBuilder.physicsManager.removeGravityBehavior(from: leftAmmo)
//
//        self.levelBuilder.updateAmmoLocation(for: leftWeapon, ammo: leftAmmo)
//
//        leftAmmo.isHidden = false
//
//        self.levelBuilder.physicsManager.addGravityBehavior(view: leftAmmo)
//        self.levelBuilder.physicsManager.shot(item: leftAmmo, from: leftWeapon, toSide: .right)
//
        
        
        self.stopAnimation(for: .player1)
        let leftWeapon = self.gameScene.subviews[4]
        let leftAmmo = self.gameScene.subviews[6]
        
        self.levelBuilder.physicsManager.removeGravityBehavior(from: leftAmmo)

        self.levelBuilder.updateAmmoLocation(for: leftWeapon, ammo: leftAmmo)
        
        leftAmmo.isHidden = false
        
        self.levelBuilder.physicsManager.addGravityBehavior(view: leftAmmo)
        self.levelBuilder.physicsManager.shot(item: leftAmmo, from: leftWeapon, toSide: .right)
    }

    // Handle right tap gesture
    @objc func rightTapped() {
        self.stopAnimation(for: .player2)
        
        let rightWeapon = self.gameScene.subviews[5]
        let rightAmmo = self.gameScene.subviews[7]
        
        self.levelBuilder.physicsManager.removeGravityBehavior(from: rightAmmo)
        
        self.levelBuilder.updateAmmoLocation(for: rightWeapon, ammo: rightAmmo)
        rightAmmo.isHidden = false
        self.levelBuilder.physicsManager.shot(item: rightAmmo, from: rightWeapon, toSide: .left)
        self.levelBuilder.physicsManager.addGravityBehavior(view: rightAmmo)
    
    }
    
    func buildLevel(level: Int){
        self.levelBuilder = LevelBuilder(level: level)
        
        self.gameScene = levelBuilder.buildLevel(gameScene: gameScene)
        self.view.addSubview(self.gameScene)
        levelBuilder.initializePhysicsBehavior(parentView: self.gameScene)
        
        self.levelBuilder.physicsManager.collisionBehavior.collisionDelegate = self


        let leftSideTapView = self.gameScene.subviews[8]
        let rightSideTapView = self.gameScene.subviews[9]
        
        let leftTapGesture = UITapGestureRecognizer()
        let rightTapGesture = UITapGestureRecognizer()

        // Set up target actions for the gestures
        leftTapGesture.addTarget(self, action: #selector(leftTapped))
        rightTapGesture.addTarget(self, action: #selector(rightTapped))
        
        // Add tap gestures to the left and right views
        leftSideTapView.addGestureRecognizer(leftTapGesture)
        rightSideTapView.addGestureRecognizer(rightTapGesture)


        
        self.startAnimation(for: .player1)
        
        
        let leftAmmo = self.gameScene.subviews[6]
        let rightAmmo = self.gameScene.subviews[7]

        leftAmmo.isHidden = true
        rightAmmo.isHidden = true
        
    }
}


extension GameSceneViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, with otherItem: UIDynamicItem, at point: CGPoint) {
        
        if !self.isGameFinished {
            
            
            if let view = item as? UIView, let otherView = otherItem as? UIView {
                if otherView == self.gameScene.subviews[6] && view == self.gameScene.subviews[2] {
                    self.viewModel.onHit()
                    self.gameScene.subviews[6].isHidden = true
                    self.gameScene.subviews[5].transform = CGAffineTransform(rotationAngle:(CGFloat(-90).degreesToRadians))

                    let leftWeapon = self.gameScene.subviews[4]
                    let leftAmmo = self.gameScene.subviews[6]

                    self.levelBuilder.physicsManager.removeGravityBehavior(from: leftAmmo)

                    self.levelBuilder.updateAmmoLocation(for: leftWeapon, ammo: leftAmmo)
                    
                    
                    self.startAnimation(for: .player2)
                }
                
                if otherView == self.gameScene.subviews[7] && view == self.gameScene.subviews[1] {
                    self.viewModel.onHit()
                    self.gameScene.subviews[7].isHidden = true
                    self.gameScene.subviews[4].transform = CGAffineTransform(rotationAngle:(CGFloat(90).degreesToRadians))

                    let rightWeapon = self.gameScene.subviews[5]
                    let rightAmmo = self.gameScene.subviews[7]

                    self.levelBuilder.physicsManager.removeGravityBehavior(from: rightAmmo)

                    self.levelBuilder.updateAmmoLocation(for: rightWeapon, ammo: rightAmmo)

                    self.startAnimation(for: .player1)
                }
            }
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if let view = item as? UIView {
            self.viewModel.onMiss()
            if view == self.gameScene.subviews[6] {

            } else if view == self.gameScene.subviews[7]{
                
            }
        }
        
    }
}




