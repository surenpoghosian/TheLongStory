//
//  Greedy_KingsTests.swift
//  Greedy KingsTests
//
//  Created by Suren Poghosyan on 21.09.23.
//

import XCTest
@testable import Greedy_Kings

final class GameManagerTests: XCTestCase {
    var gameManager: GameManager!
    var healthManager: HealthManager!

    override func setUpWithError() throws {
        gameManager = GameManager()
        healthManager = HealthManager()
    }

    override func tearDownWithError() throws {
        gameManager = nil
        healthManager = nil
    }

    func testGameManagerInitialization() throws {
        if gameManager == nil {
            XCTFail("game manager failed initialization")
        }
    }

    func testHealthManagerInitialization() throws {
        if healthManager == nil {
            XCTFail("health manager failed initialization")
        }
    }

    
    func testUdateHealth() throws {
        healthManager.resetHealth()
        
        XCTAssertEqual(healthManager.getHealth(player: .player2), 100)
        XCTAssertEqual(healthManager.getHealth(player: .player1), 100)
        
        healthManager.setHealth(player: .player1, health: 90)
        healthManager.setHealth(player: .player2, health: 90)
        
        XCTAssertEqual(healthManager.getHealth(player: .player1), 90)
        XCTAssertEqual(healthManager.getHealth(player: .player2), 90)
        
        healthManager.resetHealth()
        
        healthManager.decreaseHealth(player: .player1, by: 20)
        healthManager.decreaseHealth(player: .player2, by: 20)
        
        XCTAssertEqual(healthManager.getHealth(player: .player1), 80)
        XCTAssertEqual(healthManager.getHealth(player: .player2), 80)
        
        healthManager.resetHealth()
    }

    
    func testBattleResult() throws {
        healthManager.setHealth(player: .player1, health: 0)
        XCTAssertEqual(healthManager.getHealth(player: .player1), 0)
        
        let battleResult = gameManager.checkIsGameFinished()
        
        if battleResult == nil {
            XCTFail("Failed to finish the game")
        }

        XCTAssertEqual(battleResult?.winner, gameManager.currentPlayer)
    }


    
    
//    func testUserSwitcher() throws {
//        if gameManager.currentPlayer == .player1 {
//            gameManager.switchPlayerTurn()
//            XCTAssertEqual(gameManager.currentPlayer, .player2)
//        } else {
//            gameManager.switchPlayerTurn()
//            XCTAssertEqual(gameManager.currentPlayer, .player1)
//        }
//
//    }
    
//    func testSetWinner() throws {
//        gameManager.setWinner(winner: gameManager.currentPlayer)
//    }

    

}
