//
//  GameSceneViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 24.09.23.
//

import UIKit
import Lottie

final class GameSceneViewController: UIViewController {
    weak var delegate: GameDataDelegate?
    private var viewModel: GameSceneViewModel!
    private var levelBuilder: LevelBuilder!
    private var gameScene: UIView!
    var audioManager: AudioManager!
    var hapticsManager: HapticsManager!
    var viewanimator1: UIViewPropertyAnimator!
    var viewanimator1_2: UIViewPropertyAnimator!
    var viewanimator2: UIViewPropertyAnimator!
    var viewanimator2_2: UIViewPropertyAnimator!
    var isGameFinished: Bool = false
    var temporaryCurrentPlayer: Player?
    var longPressStartTime: Date?
    var countdownTimer: Timer?
    var totalTime: Int = 10
    var isTimerRunning: Bool = false
    var animation: Animation!
    
    override func viewWillDisappear(_ animated: Bool) {
        isGameFinished = true
        audioManager.stopAudio(type: .background)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GameSceneViewModel()
        viewModel.gameFinished = gameFinished
        audioManager = AudioManager()
        animation = Animation()
//        audioManager.playAudio(type: .background)
        hapticsManager = HapticsManager()
        initializeGameScene()
        buildLevel(level: 1)
        startTimer()
    }
        
    func initializeGameScene(){
        gameScene = UIView()
        gameScene.frame = view.bounds
        navigationItem.hidesBackButton = true
    }
    
    
    func updateTimerLabel() {
        let timerLabel = gameScene.subviews[10] as? UILabel
        timerLabel?.text = String(totalTime)
    }
    
    func setTimerLabelVisiblity(_ state: Bool){
        let timerLabel = gameScene.subviews[10] as? UILabel
        timerLabel?.isHidden = !state
    }
    
    
    func startTimer() {
        if !isTimerRunning {
            isTimerRunning = true
            countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        updateTimerLabel()
    }
    
    func stopTimer() {
        if isTimerRunning {
            isTimerRunning = false
            countdownTimer?.invalidate()
        }
        updateTimerLabel()
    }
    
    func resetTimer() {
        if isTimerRunning {
            stopTimer()
        }
        totalTime = 10
        updateTimerLabel()
    }
    
    @objc func updateTimer() {
        if totalTime > 0 {
            totalTime -= 1
            updateTimerLabel()
        } else {
            stopTimer()

            switch viewModel.currentPlayer! {
            case .player1:
                stopAnimation(for: .player1)
                onLongpressEnd(pressInterval: 1.2)
            case .player2:
                stopAnimation(for: .player2)
                onLongpressEnd(pressInterval: 1.2)
            }
        }
    }
    
    func prepareAndShot(ammo: UIView, weapon: UIView, strength: Double, toSide: Side){
        levelBuilder.physicsManager.removeGravityBehavior(from: ammo)
        
        levelBuilder.updateAmmoLocation(for: weapon, ammo: ammo)
        
        levelBuilder.updateAmmoVisiblity(for: ammo, isHidden: false)
        
        levelBuilder.physicsManager.addGravityBehavior(view: ammo)
        levelBuilder.physicsManager.shot(item: ammo, from: weapon, toSide: toSide, strength: strength)
        audioManager.playAudio(type: .shot)
        setTapRecognitionState(disabled: true)
        stopTimer()
        hapticsManager.generate(type: .heavy)
    }
    
    @objc func onLongpressEnd(pressInterval: Double){
        //        for disabling multiple calls of onmiss and onhit, the code validates in delegate function call, was the temporarycurrentPlayer changed after touch in screen,
        temporaryCurrentPlayer = viewModel.currentPlayer

        if let player = viewModel.currentPlayer {
            switch player {
            case .player1:
                let leftWeapon = gameScene.subviews[4]
                let leftAmmo = gameScene.subviews[6]
                

                prepareAndShot(ammo: leftAmmo, weapon: leftWeapon, strength: pressInterval, toSide: .right)
                
            case .player2:
                let rightWeapon = gameScene.subviews[5]
                let rightAmmo = gameScene.subviews[7]
                
                prepareAndShot(ammo: rightAmmo, weapon: rightWeapon, strength: pressInterval, toSide: .left)
                
            }
            
        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            longPressStartTime = Date()
            
            if let player = viewModel.currentPlayer {
                switch player {
                case .player1:
                    stopAnimation(for: .player1)
                case .player2:
                    stopAnimation(for: .player2)
                }
            }
        } else if gestureRecognizer.state == .ended {
            if let startTime = longPressStartTime {
                let endTime = Date()
                let duration = endTime.timeIntervalSince(startTime)
                                
                onLongpressEnd(pressInterval: duration)
                longPressStartTime = nil
            }
            
            
        }
    }
    
    func buildLevel(level: Int){
        levelBuilder = LevelBuilder(level: level)
        
        gameScene = levelBuilder.buildLevel(gameScene: gameScene)
        view.addSubview(gameScene)
        levelBuilder.initializePhysicsBehavior(parentView: gameScene)
        
        levelBuilder.physicsManager.collisionBehavior.collisionDelegate = self
        
        let fullScreenTapView = gameScene.subviews[11]
        
        let fullScreenLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        
        fullScreenTapView.addGestureRecognizer(fullScreenLongPressGesture)
        
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
    
    func updateHealthScale(player: Player){
        switch player {
        case .player1:
            levelBuilder.updatePlayerHealthIndicator(health: HealthManager.shared.player1health, referenceView: gameScene.subviews[8], side: .left)

        case .player2:
            levelBuilder.updatePlayerHealthIndicator(health: HealthManager.shared.player2health, referenceView: gameScene.subviews[9], side: .right)

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
        
        resetTimer()
        startTimer()
    }
    
    func setTapRecognitionState(disabled state: Bool){
        let tapView = gameScene.subviews[11]
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
    
    
    func gameFinished() {
        isGameFinished = true
        audioManager.stopAudio(type: .background)
        audioManager.playAudio(type: .finished)
        stopAnimation(for: .player1)
        stopAnimation(for: .player2)
        setTapRecognitionState(disabled: true)
        stopTimer()
        resetTimer()
        
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
                            
                            let viewOrigin = view.frame.origin
                            print("onhit",viewOrigin)
                            
                            animation.play(x: viewOrigin.x, y: viewOrigin.y, type: .hit, referenceView: gameScene)

                            stopTimer()
                            self.temporaryCurrentPlayer = nil
                            audioManager.playAudio(type: .hit)
                            viewModel.onHit()
                            updateHealthScale(player: .player2)
                            hapticsManager.generate(type: .medium)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                                if !self.isGameFinished{

                                    
                                    self.updatePlayerState(side: .left)
                                    self.setTapRecognitionState(disabled: false)
                                }
                            })
                            
                            levelBuilder.updateAmmoVisiblity(for: leftAmmo, isHidden: true)
                        }
                    }
                    
                } else if otherView == rightAmmo && view == leftCastle {
                    if let temporaryCurrentPlayer{
                        if temporaryCurrentPlayer == viewModel.currentPlayer {
                            let viewOrigin = view.frame.origin
                            print("onhit",viewOrigin)
                            
                            animation.play(x: viewOrigin.x, y: viewOrigin.y, type: .hit, referenceView: gameScene)
 
                            stopTimer()
                            self.temporaryCurrentPlayer = nil
                            audioManager.playAudio(type: .hit)
                            viewModel.onHit()
                            updateHealthScale(player: .player1)
                            hapticsManager.generate(type: .medium)
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                                if !self.isGameFinished{
                                    
                                    
                                    self.updatePlayerState(side: .right)
                                    self.setTapRecognitionState(disabled: false)
                                }
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
            
            if itemFrame.intersects(upperBoundaryFrame) {
                print("upper edge")
            } else {
                let leftAmmo = gameScene.subviews[6]
                let rightAmmo = gameScene.subviews[7]
                
                if view == leftAmmo {
                    
                    if let temporaryCurrentPlayer {
                        print(temporaryCurrentPlayer)
                        if temporaryCurrentPlayer == viewModel.currentPlayer {
                            
                            let viewOrigin = view.frame.origin
                            print("onmiss",viewOrigin)
                            
                            animation.play(x: viewOrigin.x, y: viewOrigin.y, type: .miss, referenceView: gameScene)
                            stopTimer()
                            self.temporaryCurrentPlayer = nil
                            viewModel.onMiss()
                            audioManager.playAudio(type: .miss)
                            levelBuilder.updateAmmoVisiblity(for: leftAmmo, isHidden: true)

                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                                if !self.isGameFinished{
                                    self.updatePlayerState(side: .left)
                                    self.setTapRecognitionState(disabled: false)
                                }
                            })
                        }
                    }
                    
                    
                } else if view == rightAmmo {
                    if let temporaryCurrentPlayer {
                        if temporaryCurrentPlayer == viewModel.currentPlayer {
                            let viewOrigin = view.frame.origin
                            print("onmiss",viewOrigin)

                            animation.play(x: viewOrigin.x, y: viewOrigin.y, type: .miss, referenceView: gameScene)
                            stopTimer()
                            self.temporaryCurrentPlayer = nil
                            viewModel.onMiss()
                            audioManager.playAudio(type: .miss)
                            levelBuilder.updateAmmoVisiblity(for: rightAmmo, isHidden: true)

                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                                if !self.isGameFinished{
                                    self.updatePlayerState(side: .right)
                                    self.setTapRecognitionState(disabled: false)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}




