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
    
    init() {
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
        if HealthManager.shared.player1health <= 0 || HealthManager.shared.player2health <= 0 {
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
            HealthManager.shared.player2health -= 20
        } else {
            HealthManager.shared.player1health -= 20
        }
    }
    
    // set the winner to the player
    func setWinner(winner: Player) {
        battleResult.winner = winner
    }
    
    // reset health and battle stats
    func resetHealth() {
        HealthManager.shared.player1health = 100
        HealthManager.shared.player1health = 100
        initializeBattleResult()
    }
}
