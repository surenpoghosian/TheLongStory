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
    
    init(){
        gameManager = GameManager()
        gameManager.startGame()

    }
    
    func onHit() {
        gameManager.updateHits()
        gameManager.updateShots()
        gameManager.updateHealth()
        let battleFinished = gameManager.checkIsGameFinished()
        
        if let gameFinishedResults = battleFinished {
            gameFinished!()
        } else {
            print("game is not finished yet")
        }
        
        print("p1 ",HealthManager.shared.player1health,"p2 ", HealthManager.shared.player2health)
    }
    
    func onMiss() {
        gameManager.updateShots()
    }
    
    func onCloseDuringBattle() {
        
    }
}
