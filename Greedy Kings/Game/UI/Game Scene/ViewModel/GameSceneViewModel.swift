//
//  ViewModel.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 22.09.23.
//

import Foundation

final class GameSceneViewModel {
    
    private var gameManager: GameManager
    var resetAmmo: (() -> Void)?
    var gameFinished: (() -> Void)?
    private(set) var currentPlayer: Player?
    
    init(){
        gameManager = GameManager()
        gameManager.startGame()
        currentPlayer = gameManager.currentPlayer
    }
    
    func onHit() {
        gameManager.updateHits()
        gameManager.updateShots()
        gameManager.updateHealth()
        let battleFinished = gameManager.checkIsGameFinished()
        
        if let _ = battleFinished {
            gameFinished!()
        } else {
            print("game is not finished yet")
        }
        
        print("p1 ",HealthManager.shared.player1health,"p2 ", HealthManager.shared.player2health)

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
    
    func onCloseDuringBattle() {
        
    }
}
