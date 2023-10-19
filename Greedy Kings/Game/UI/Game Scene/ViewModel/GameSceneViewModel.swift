//
//  ViewModel.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 22.09.23.
//

import Foundation

final class GameSceneViewModel {
    
    private var gameManager: GameManager
    private(set) var currentPlayer: Player?
    var resetAmmo: (() -> Void)?
    var onGameFinished: (() -> Void)?
    var onRematch: (() -> Void)?
    var healthManager: HealthManager!

    init(){
        gameManager = GameManager()
        gameManager.startGame()
        currentPlayer = gameManager.currentPlayer
        healthManager = HealthManager()
    }
     
    func onHit() {
        gameManager.updateHits()
        gameManager.updateShots()
        gameManager.updateHealth()
        let battleFinished = gameManager.checkIsGameFinished()
        
        if let _ = battleFinished {
            onGameFinished!()
        } else {
            print("game is not finished yet")
        }

        updateCurrentPlayer(player: gameManager.currentPlayer)
    }
    
    private func updateCurrentPlayer(player: Player){
        self.currentPlayer = player
    }
    
    func onMiss() {
        gameManager.updateShots()
        let _ = gameManager.checkIsGameFinished()

        updateCurrentPlayer(player: gameManager.currentPlayer)
    }
    
    func onTimeOut(){
        let _ = gameManager.checkIsGameFinished()
        updateCurrentPlayer(player: gameManager.currentPlayer)
    }
    
    func rematch() {
        if let onRematch = onRematch {
            onRematch()
        }
        
        gameManager = GameManager()
        updateCurrentPlayer(player: gameManager.currentPlayer)
    }
    
    func onStart(){
        updateCurrentPlayer(player: .player1)
        gameManager.resetHealth()
        gameManager.startGame()
    }
    
    func onContinue(battleModel: BattleModel){
        healthManager.setHealth(player: .player1, health: battleModel.player1Health)
        healthManager.setHealth(player: .player2, health: battleModel.player2Health)
    }

    deinit {
        print("deinit viewmodel")
    }
}
