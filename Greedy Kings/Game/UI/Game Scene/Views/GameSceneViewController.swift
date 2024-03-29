//
//  GameSceneViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 24.09.23.
//

import UIKit
import Lottie
import StoreKit

final class GameSceneViewController: UIViewController {
    private var viewModel: GameSceneViewModel!
    private var levelBuilder: LevelBuilder!
    private var gameScene: UIView!
    private var audioManager: AudioManager!
    private var hapticsManager: HapticsManager!
    private var storageManager: StorageManager!
    
    private var viewanimator1: UIViewPropertyAnimator!
    private var viewanimator1_2: UIViewPropertyAnimator!
    private var viewanimator2: UIViewPropertyAnimator!
    private var viewanimator2_2: UIViewPropertyAnimator!
    
    private var temporaryCurrentPlayer: Player?
    private var longPressStartTime: Date?
    private var countdownTimer: Timer?
    private var totalTime: Int = 10
    
    private var animation: Animation!
    var battleModel: BattleModel?
    var pickedCharacters: PickedCharacters?
    var levelType: LevelType?
    
    private var isGameFinished: Bool = false
    private var isTimerRunning: Bool = false
    var isPaused: Bool = false
    
    var healthManager: HealthManager!
    
    override func viewWillDisappear(_ animated: Bool) {
        onClose()
    }
    
    func onClose(){
        isGameFinished = true
        if let audioManager {
            audioManager.stopAudio(type: .background)
        }
        
        levelBuilder = nil
        hapticsManager = nil
        audioManager = nil
        viewModel = nil
        stopTimer()
        countdownTimer = nil
        animation = nil
        
        removeBackgroundModeObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        healthManager = HealthManager()
        
        viewModel = GameSceneViewModel()
        viewModel.onGameFinished = onGameFinished
        viewModel.onRematch = onRematch
        
        audioManager = AudioManager()
        animation = Animation()
        audioManager.playAudio(type: .background)
        
        storageManager = StorageManager()
        
        hapticsManager = HapticsManager()
        
        initializeGameScene()
        
        buildLevel(scene: levelType!, battleModel: battleModel)

        setCharactersIcons(characters: pickedCharacters)
        
        if isFirstGame() {
            showHintModal()
        } else {
            startTimer()
            startAnimation(for: .player1)
        }
        
        addSwitchToBackgroundModeObserver()
        
    }
    
    
    func isFirstGame() -> Bool{
    
        if let _ = storageManager.get(key: "firstGame", storageType: .userdefaults) as? String {
            return false
            
        } else {
                storageManager.set(key: "firstGame", value: "data", storageType: .userdefaults)
                return true
            
        }
    }
    
    func initializeGameScene(){
        gameScene = nil
        gameScene = UIView()
        gameScene.frame = view.bounds
        navigationItem.hidesBackButton = true
    }
    
    
    func setCharactersIcons(characters: PickedCharacters?){
        if let characters {
            let player1ImageView = gameScene.subviews[8].subviews[1] as! UIImageView
            let player2ImageView = gameScene.subviews[9].subviews[1] as! UIImageView
            
            player1ImageView.image = UIImage(named: characters.player1Character.avatarID)
            player2ImageView.image = UIImage(named: characters.player2Character.avatarID)
        }
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
        
        let weaponOrigin = weapon.frame.origin
        animation.play(x: weaponOrigin.x, y: weaponOrigin.y, type: .shot, referenceView: gameScene)
        
        audioManager.playAudio(type: .shot)
        
        hapticsManager.generate(type: .heavy)
        
        setTapRecognitionState(disabled: true)
        
        stopTimer()
        
    }
    
    @objc func onLongpressEnd(pressInterval: Double){
        //        for disabling multiple calls of onmiss and onhit, the code validates in delegate function call, was the temporarycurrentPlayer changed after touch in screen,
        temporaryCurrentPlayer = viewModel.currentPlayer
        
        if let player = viewModel.currentPlayer {
            switch player {
            case .player1:
                let leftWeapon = gameScene.subviews[4]
                let leftAmmo = gameScene.subviews[6]
                
                if let _ = levelBuilder{
                    prepareAndShot(ammo: leftAmmo, weapon: leftWeapon, strength: pressInterval, toSide: .right)
                }
                
                
            case .player2:
                let rightWeapon = gameScene.subviews[5]
                let rightAmmo = gameScene.subviews[7]
                if let _ = levelBuilder{
                    prepareAndShot(ammo: rightAmmo, weapon: rightWeapon, strength: pressInterval, toSide: .left)
                }
                
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
                
                //                adding strength animation to gamescene
                let screenSize = UIScreen.main.bounds
                animation.play(x: screenSize.width / 2, y: screenSize.height, type: .strength, referenceView: gameScene)
            }
            
            
        } else if gestureRecognizer.state == .ended {
            if let startTime = longPressStartTime {
                let endTime = Date()
                let duration = endTime.timeIntervalSince(startTime)
                
                onLongpressEnd(pressInterval: duration)
                longPressStartTime = nil
                
                //                in this block i'm stopping the strength animation :D
                let strengthView = self.gameScene.subviews.first(where: {
                    $0.tag == 96
                })
                
                if let strengthView {
                    animation.stop(referenceView: gameScene, animationView: (strengthView as? LottieAnimationView)!)
                }
                
            }
            
            
        }
    }
    
    @objc func onPause(){
        isPaused = true
        stopTimer()
        stopAnimation(for: viewModel.currentPlayer!)
        showPauseModal()
    }
    
    func onContinue(){
        isPaused = false
        startAnimation(for: viewModel.currentPlayer!)
        startTimer()
    }
    
    func showPauseModal(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "PauseView") as? PauseViewController {
            vc.viewModel = viewModel
            vc.onMainMenu = onMainMenu
            vc.onContinue = onContinue
            navigationController?.present(vc, animated: true)
        }
    }
    
    func buildLevel(scene: LevelType, battleModel: BattleModel? = nil){
        levelBuilder = LevelBuilder(type: scene)
        
        gameScene = levelBuilder.buildLevel(gameScene: gameScene)
        view.addSubview(gameScene)
        levelBuilder.initializePhysicsBehavior(parentView: gameScene)
        
        levelBuilder.physicsManager.collisionBehavior.collisionDelegate = self
        
        let fullScreenTapView = gameScene.subviews[11]
        
        let fullScreenLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        
        fullScreenTapView.addGestureRecognizer(fullScreenLongPressGesture)
        
        let pauseButton = gameScene.subviews[12] as! UIButton
        
        pauseButton.addTarget(self, action: #selector(onPause), for: .touchUpInside)
        
        
        let leftAmmo = gameScene.subviews[6]
        let rightAmmo = gameScene.subviews[7]
        
        levelBuilder.updateAmmoVisiblity(for: leftAmmo, isHidden: true)
        levelBuilder.updateAmmoVisiblity(for: rightAmmo, isHidden: true)
        
        if let battleModel {
            print("battleModel")
            pickedCharacters = PickedCharacters(player1Character: battleModel.player1Character, player2Character: battleModel.player2Character)
            viewModel.onContinue(battleModel: battleModel)
            self.updateHealthScale(player: .player1)
            self.updateHealthScale(player: .player2)
        } else {
            
            print("NON battleModel")
        }
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
            levelBuilder.updatePlayerHealthIndicator(health: healthManager.getHealth(player: .player1), referenceView: gameScene.subviews[8], side: .left)
        case .player2:
            levelBuilder.updatePlayerHealthIndicator(health: healthManager.getHealth(player: .player2), referenceView: gameScene.subviews[9], side: .right)
        }
    }
    
    func updatePlayerState(side: Side) {
        switch side {
        case .left:
            let leftWeapon = gameScene.subviews[4]
            let leftAmmo = gameScene.subviews[6]
            
            updateAmmoState(ammo: leftAmmo, weapon: leftWeapon)
            updateWeaponPosition(weapon: leftWeapon, side: .right)
            
            if !isPaused {
                startAnimation(for: .player2)
            }
            
            
        case .right:
            let rightWeapon = gameScene.subviews[5]
            let rightAmmo = gameScene.subviews[7]
            
            updateAmmoState(ammo: rightAmmo, weapon: rightWeapon)
            updateWeaponPosition(weapon: rightWeapon, side: .left)
            if !isPaused {
                startAnimation(for: .player1)
            }
        }
        
        resetTimer()
        if !isPaused {
            startTimer()
        }
        
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
    
    func onGameFinished(_ battleResult: BattleResult) {
        isGameFinished = true
        
        audioManager.stopAudio(type: .background)
        audioManager.playAudio(type: .finished)
        
        stopAnimation(for: .player1)
        stopAnimation(for: .player2)
        
        setTapRecognitionState(disabled: true)
        
        stopTimer()
        resetTimer()
        
        let winner = determineWinner(battleResult: battleResult)
        showResultModal(winner: winner)
        updateWins(name: winner.name, increment: 1)
        
        storageManager.remove(key: "game", storageType: .userdefaults)
    }
    
    
    func updateWins(name: String, increment: Int) {
        if let data = storageManager.get(key: "leaderboard", storageType: .userdefaults) as? Data {
            let decoder = JSONDecoder()
            if let leaderboard = try? decoder.decode([LeaderboardItem].self, from: data) {
                let newLeaderBoard = increaseWins(for: name, in: leaderboard)
                
                let encoder = JSONEncoder()
                if let encodedData = try? encoder.encode(newLeaderBoard) {
                    storageManager.set(key: "leaderboard", value: encodedData, storageType: .userdefaults)
                }
            }
        }
        
    }
    
    func increaseWins(for playerName: String, in leaderboardItems: [LeaderboardItem]) -> [LeaderboardItem] {
        return leaderboardItems.map { item in
            var updatedItem = item
            if item.playerName == playerName {
                updatedItem.wins += 1
            }
            return updatedItem
        }
    }
    
    
    func determineWinner(battleResult: BattleResult) -> Character {
        var winner: Character
        
        switch battleResult.winner! {
        case .player1:
            winner = pickedCharacters!.player1Character
        case .player2:
            winner = pickedCharacters!.player2Character
        }
        
        return winner
    }
    
    func showResultModal(winner: Character){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "ResultView") as? ResultViewController {
            
            vc.winner = winner
            vc.viewModel = viewModel
            vc.onMainMenu = onMainMenu
            navigationController?.present(vc, animated: true)
        }
        
    }
    
    func showHintModal(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "HintView") as? HintViewController {
            
            vc.onHintClose = onHintClose
            navigationController?.present(vc, animated: true)
        }
        
    }

    func onHintClose(){
        startTimer()
        startAnimation(for: .player1)
    }
    
    func onHit(ammo: UIView, side: Side){
        if let temporaryCurrentPlayer {
            if temporaryCurrentPlayer == viewModel.currentPlayer {
                viewModel.onHit()
                let viewOrigin = ammo.frame.origin
                
                animation.play(x: viewOrigin.x, y: viewOrigin.y, type: .hit, referenceView: gameScene)
                stopTimer()
                self.temporaryCurrentPlayer = nil
                audioManager.playAudio(type: .hit)
                
                
                switch side {
                case .left:
                    updateHealthScale(player: .player2)
                case .right:
                    updateHealthScale(player: .player1)
                }
                
                hapticsManager.generate(type: .medium)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    if !self.isGameFinished {
                        self.updatePlayerState(side: side)
                        self.setTapRecognitionState(disabled: false)
                    }
                })
                
                levelBuilder.updateAmmoVisiblity(for: ammo, isHidden: true)
            }
        }
    }
    
    func onRematch(){
        print("on rematch")
        self.navigationController?.popViewController(animated: true)
    }
    
    func onMainMenu(){
        onClose()
        self.checkAndRequestReview()
        self.dismissToRoot(animated: true)
    }
    
    func onMiss(ammo: UIView, side: Side){
        if let temporaryCurrentPlayer {
            if temporaryCurrentPlayer == viewModel.currentPlayer {
                
                let viewOrigin = ammo.frame.origin
                
                animation.play(x: viewOrigin.x, y: viewOrigin.y, type: .miss, referenceView: gameScene)
                stopTimer()
                self.temporaryCurrentPlayer = nil
                viewModel.onMiss()
                audioManager.playAudio(type: .miss)
                levelBuilder.updateAmmoVisiblity(for: ammo, isHidden: true)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                    if !self.isGameFinished {
                        self.updatePlayerState(side: side)
                        self.setTapRecognitionState(disabled: false)
                    }
                })
            }
        }
    }
    
    func addSwitchToBackgroundModeObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(onSwitchToBackgroundMode), name: .appDidEnterBackground, object: nil)
    }
    
    func removeBackgroundModeObserver(){
        NotificationCenter.default.removeObserver(self, name: .appDidEnterBackground, object: nil)
    }
    
    
    @objc func onSwitchToBackgroundMode(){
        saveGame()
    }
    
    func saveGame(){
        let player1Health = healthManager.getHealth(player: .player1)
        let player2Health = healthManager.getHealth(player: .player2)
        
        if player1Health != 100 || player2Health != 100  {
            if player2Health > 0 && player1Health > 0 {
                let battleModel = BattleModel(player1Character: pickedCharacters!.player1Character, player1Health: player1Health, player2Character: pickedCharacters!.player2Character, player2Health: player2Health, levelType: levelType!, turn: viewModel.currentPlayer!)
                
                let encoder = JSONEncoder()
                if let encodedData = try? encoder.encode(battleModel) {
                    storageManager.set(key: "game", value: encodedData, storageType: .userdefaults)
                }
            }
        } else {
            removeSavedGame()
        }
    }
    
    func removeSavedGame(){
        if let _ = self.storageManager.get(key: "game", storageType: .userdefaults) as? Data {
            storageManager.remove(key: "game", storageType: .userdefaults)
        }
        
    }
    
    
    private func checkAndRequestReview(){
        
        
        if let lastTimeCalled = storageManager.get(key: "requestReviewModal", storageType: .userdefaults) as? Data {
            let decoder = PropertyListDecoder()
            
            if let log = try? decoder.decode(RequestReviewLogItem.self, from: lastTimeCalled) {
                
                let currentDate = Date()
                
                if let fourMonthAgo = Calendar.current.date(byAdding: .month, value: -4, to: currentDate) {
                    if log.date < fourMonthAgo {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.requestReview()
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.requestReview()
            }
        }
    }
    
    private func requestReview(){
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
        
        let newLog = RequestReviewLogItem(date: Date())
        let encoder = PropertyListEncoder()
        
        if let logData = try? encoder.encode(newLog) {
            storageManager.set(key: "requestReviewModal", value: logData, storageType: .userdefaults)
        }
    }
    
    
    deinit {
        print("deinit")
        removeBackgroundModeObserver()
        onClose()
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
                    self.onHit(ammo: leftAmmo, side: .left)
                    
                } else if otherView == rightAmmo && view == leftCastle {
                    self.onHit(ammo: rightAmmo, side: .right)
                    
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
                    self.onMiss(ammo: leftAmmo, side: .left)
                    
                } else if view == rightAmmo {
                    self.onMiss(ammo: rightAmmo, side: .right)
                    
                }
            }
        }
    }
}




