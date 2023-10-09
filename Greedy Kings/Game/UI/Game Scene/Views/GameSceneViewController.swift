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
    var temporaryCurrentPlayer: Player?
    
    override func viewWillDisappear(_ animated: Bool) {
        isGameFinished = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GameSceneViewModel()
        viewModel.gameFinished = gameFinished
        
        initializeGameScene()
        buildLevel(level: 1)

    }
        
    func gameFinished() {
        isGameFinished = true
        print("isGameFinished", isGameFinished)
    }
        
    func initializeGameScene(){
        gameScene = UIView()
        gameScene.frame = view.bounds
    }


    @objc func screenTapped(){
//        for disabling multiple calls of onmiss and onhit, the code validates in delegate function call, was the temporarycurrentPlayer changed after touch in screen, 
        temporaryCurrentPlayer = viewModel.currentPlayer
        
        if let player = viewModel.currentPlayer {
            switch player {
            case .player1:
                stopAnimation(for: .player1)
                let leftWeapon = gameScene.subviews[4]
                let leftAmmo = gameScene.subviews[6]
                
                levelBuilder.physicsManager.removeGravityBehavior(from: leftAmmo)
                
                levelBuilder.updateAmmoLocation(for: leftWeapon, ammo: leftAmmo)
                
                levelBuilder.updateAmmoVisiblity(for: leftAmmo, isHidden: false)
                
                levelBuilder.physicsManager.addGravityBehavior(view: leftAmmo)
                levelBuilder.physicsManager.shot(item: leftAmmo, from: leftWeapon, toSide: .right)
                setTapRecognitionState(disabled: true)
            case .player2:
                stopAnimation(for: .player2)
                let rightWeapon = gameScene.subviews[5]
                let rightAmmo = gameScene.subviews[7]
                
                levelBuilder.physicsManager.removeGravityBehavior(from: rightAmmo)
                
                
                levelBuilder.updateAmmoLocation(for: rightWeapon, ammo: rightAmmo)
                
                
                levelBuilder.updateAmmoVisiblity(for: rightAmmo, isHidden: false)
                
                levelBuilder.physicsManager.addGravityBehavior(view: rightAmmo)
                levelBuilder.physicsManager.shot(item: rightAmmo, from: rightWeapon, toSide: .left)
                
                setTapRecognitionState(disabled: true)
            }
            
        }
    }

    
    func buildLevel(level: Int){
        levelBuilder = LevelBuilder(level: level)
        
        gameScene = levelBuilder.buildLevel(gameScene: gameScene)
        view.addSubview(gameScene)
        levelBuilder.initializePhysicsBehavior(parentView: gameScene)
        
        levelBuilder.physicsManager.collisionBehavior.collisionDelegate = self


        let fullScreenTapView = gameScene.subviews[8]
        
        let fullScreenTapGesture = UITapGestureRecognizer()
        
        fullScreenTapGesture.addTarget(self, action: #selector(screenTapped))
        
        fullScreenTapView.addGestureRecognizer(fullScreenTapGesture)
        
        startAnimation(for: .player1)
                
        let leftAmmo = gameScene.subviews[6]
        let rightAmmo = gameScene.subviews[7]

        levelBuilder.updateAmmoVisiblity(for: leftAmmo, isHidden: true)
        levelBuilder.updateAmmoVisiblity(for: rightAmmo, isHidden: true)
    }
    
    func updateAmmoState(ammo: UIView, weapon: UIView){
        levelBuilder.updateAmmoVisiblity(for: ammo, isHidden: true)
        
        levelBuilder.physicsManager.removeGravityBehavior(from: ammo)
        
        levelBuilder.updateAmmoLocation(for: weapon, ammo: ammo)
    }
    
    func updateWeaponPosition(weapon: UIView, side: Side){
        switch side {
        case .left:
            weapon.transform = CGAffineTransform(rotationAngle:(CGFloat(-90).degreesToRadians))
        case .right:
            weapon.transform = CGAffineTransform(rotationAngle:(CGFloat(90).degreesToRadians))
        }
    }
    
    func updatePlayerState(side: Side){
        switch side {
        case .left:
            let leftWeapon = gameScene.subviews[4]
            let leftAmmo = gameScene.subviews[6]
            
            updateAmmoState(ammo: leftAmmo, weapon: leftWeapon)
            updateWeaponPosition(weapon: leftWeapon, side: .right)
            startAnimation(for: .player2)

        case .right:
            let rightWeapon = gameScene.subviews[5]
            let rightAmmo = gameScene.subviews[7]

            updateAmmoState(ammo: rightAmmo, weapon: rightWeapon)
            updateWeaponPosition(weapon: rightWeapon, side: .left)
            startAnimation(for: .player1)
        }
    }
    
    func setTapRecognitionState(disabled state: Bool){
        let tapView = gameScene.subviews[8]
        tapView.isHidden = state
    }
    
    func stopAnimation(for player: Player){
        switch player{
            case .player1:
                if let _ = viewanimator1{
                    viewanimator1.stopAnimation(true)
                    viewanimator1 = nil
                }
                if let _ = viewanimator1_2{
                    viewanimator1_2.stopAnimation(true)
                    viewanimator1_2 = nil
                }
            case .player2:
                if let _ = viewanimator2{
                    viewanimator2.stopAnimation(true)
                    viewanimator2 = nil
                }
                if let _ = viewanimator2_2{
                    viewanimator2_2.stopAnimation(true)
                    viewanimator2_2 = nil
                }
        }
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
    
}


extension GameSceneViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, with otherItem: UIDynamicItem, at point: CGPoint) {
        
        if !isGameFinished {
            let leftAmmo = gameScene.subviews[6]
            let rightCastle = gameScene.subviews[2]
            let rightAmmo = gameScene.subviews[7]
            let leftCastle = gameScene.subviews[1]
            
            if let view = item as? UIView, let otherView = otherItem as? UIView {
                        
                        if otherView == leftAmmo && view == rightCastle {
                            if let temporaryCurrentPlayer{
                            if temporaryCurrentPlayer == viewModel.currentPlayer {
                                self.temporaryCurrentPlayer = nil

                            viewModel.onHit()
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                                self.updatePlayerState(side: .left)
                                self.setTapRecognitionState(disabled: false)
                            })
                            
                            levelBuilder.updateAmmoVisiblity(for: leftAmmo, isHidden: true)
                            }
                        }

                            
                        } else if otherView == rightAmmo && view == leftCastle {
                            if let temporaryCurrentPlayer{
                            if temporaryCurrentPlayer == viewModel.currentPlayer {
                                self.temporaryCurrentPlayer = nil

                            viewModel.onHit()
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                                self.updatePlayerState(side: .right)
                                self.setTapRecognitionState(disabled: false)
                            })
                            levelBuilder.updateAmmoVisiblity(for: rightAmmo, isHidden: true)

                        }
                    }

                        }
                    }
                    
        }
    }
        
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        if let view = item as? UIView {
            
            
            let itemFrame = view.frame
            
            let upperBoundaryFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
//            let lowerBoundaryFrame = CGRect(x: 0, y: self.view.frame.height - 20, width: self.view.frame.width, height: 20)
//            let leftBoundaryFrame = CGRect(x: 0, y: 0, width: 20, height: self.view.frame.height)
//            let rightBoundaryFrame = CGRect(x: self.view.frame.width - 20, y: 0, width: 20, height: self.view.frame.height)
            
            if itemFrame.intersects(upperBoundaryFrame) {
                print("upper edge")
            } else {
                        let leftAmmo = gameScene.subviews[6]
                        let rightAmmo = gameScene.subviews[7]
                        
                        if view == leftAmmo {
                            if let temporaryCurrentPlayer {
                                if temporaryCurrentPlayer == viewModel.currentPlayer {
                                    self.temporaryCurrentPlayer = nil
                                    viewModel.onMiss()

                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                                self.updatePlayerState(side: .left)
                                self.setTapRecognitionState(disabled: false)
                            })
                            levelBuilder.updateAmmoVisiblity(for: leftAmmo, isHidden: true)
                                }
                            }

                                    
                        } else if view == rightAmmo {
                            if let temporaryCurrentPlayer {
                                if temporaryCurrentPlayer == viewModel.currentPlayer {
                                    self.temporaryCurrentPlayer = nil
                                    viewModel.onMiss()

                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                                self.updatePlayerState(side: .right)
                                self.setTapRecognitionState(disabled: false)
                            })
                            levelBuilder.updateAmmoVisiblity(for: rightAmmo, isHidden: true)
                        }
                    }

                        }
            }
            
//            else if itemFrame.intersects(lowerBoundaryFrame) {
//                print("lower")
//            } else if itemFrame.intersects(leftBoundaryFrame) {
//                print("left")
//            } else if itemFrame.intersects(rightBoundaryFrame) {
//                print("right")
//            }
        }
    }

    
}




