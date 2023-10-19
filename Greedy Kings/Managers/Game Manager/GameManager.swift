//
//  GameManager.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 27.09.23.
//

import Foundation

final class GameManager {
    private(set) var currentPlayer: Player!
    private var battleResult: BattleResult!
    private var healthManager: HealthManager!
    
    init() {
        healthManager = HealthManager()
        initializeBattleResult()
        startGame()
        
    }
    
    // set initial data
    func initializeBattleResult() {
        battleResult = BattleResult(player1Shots: 0,
                                    player1Hits: 0,
                                    player2Shots: 0,
                                    player2Hits: 0)
    }
    
    // give turn to the first player in the beginning
    func startGame() {
        currentPlayer = .player1
        resetHealth()
    }
    
    // switch player turn
    func switchPlayerTurn() {
        if currentPlayer == .player1 {
            currentPlayer = .player2
        } else {
            currentPlayer = .player1
        }
    }
    
    // updates hits score
    func updateHits() {
        if currentPlayer == .player1 {
            battleResult.player1Hits += 1
        } else {
            battleResult.player2Hits += 1
        }
    }
    
    // update shots
    func updateShots() {
        if currentPlayer == .player1 {
            battleResult.player1Shots += 1
            
        } else {
            battleResult.player2Shots += 1
        }
    }
    
    // check is the game finished
    func checkIsGameFinished() -> BattleResult? {
        if healthManager.getHealth(player: .player1) <= 0 || healthManager.getHealth(player: .player2) <= 0 {
            setWinner(winner: currentPlayer)
            return battleResult
            
        } else {
            switchPlayerTurn()
        }
        return nil
    }
    
    // update health of player after hit
    func updateHealth() {
        if currentPlayer == .player1 {
            healthManager.decreaseHealth(player: .player2, by: 20)
        } else {
            healthManager.decreaseHealth(player: .player1, by: 20)
        }
    }
    
    // set the winner to the player
    func setWinner(winner: Player) {
        battleResult.winner = winner
    }
    
    // reset health and battle stats
    func resetHealth() {
        healthManager.resetHealth()
        initializeBattleResult()
    }
    
    deinit {
        print("gamemanager deinit")
    }
}
