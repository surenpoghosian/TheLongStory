//
//  GameManager.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 27.09.23.
//

import Foundation

final class GameManager {
    private var currentPlayer: Player!
    private var battleResult: BattleResult!
    
    init() {
        initializeBattleResult()
        startGame()
    }
    
    func initializeBattleResult() {
        battleResult = BattleResult(player1Shots: 0,
                                    player1Hits: 0,
                                    player2Shots: 0,
                                    player2Hits: 0)
    }
    
    func startGame() {
        currentPlayer = .player1
    }
    
    func switchPlayerTurn() {
        if currentPlayer == .player1 {
            currentPlayer = .player2
        } else {
            currentPlayer = .player1
        }
    }
    
    func updateHits() {
        if currentPlayer == .player1 {
            battleResult.player1Hits += 1
//            checkIsGameFinished()
            
        } else {
            battleResult.player2Hits += 1
        }
//        checkIsGameFinished()
    }
    
    func updateShots() {
        if currentPlayer == .player1 {
            battleResult.player1Shots += 1
            
        } else {
            battleResult.player2Shots += 1
        }
    }
    
    func checkIsGameFinished() -> BattleResult? {
        if HealthManager.shared.player1health <= 0 || HealthManager.shared.player2health <= 0 {
            setWinner(winner: currentPlayer)
//            gameFinished()
            return battleResult
        } else {
            switchPlayerTurn()
        }
        return nil
    }
    
    func updateHealth() {
        if currentPlayer == .player1 {
            HealthManager.shared.player2health -= 20
        } else {
            HealthManager.shared.player1health -= 20
        }
    }
    
    func setWinner(winner: Player) {
        battleResult.winner = winner
    }
    
    func onGameInterrupted() {
        
    }
    
    func gameFinished() {
        
    }
}
