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
    }
    
    func onHit() {
        gameManager.startGame()
        gameManager.updateHits()
        gameManager.updateShots()
        gameManager.updateHealth()
        
        if let gameFinishedResults = gameManager.checkIsGameFinished() {
            gameFinished!()
        } else {
            
        }
        
        print("p1 ",HealthManager.shared.player1health,"p2 ", HealthManager.shared.player2health)
    }
    
    func onMiss() {
        gameManager.updateShots()
    }
    
    func onCloseDuringBattle() {
        
    }
}
