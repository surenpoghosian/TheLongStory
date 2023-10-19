//
//  HealthManager.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 06.10.23.
//

import Foundation

final class HealthManager {
    
    func decreaseHealth(player: Player, by: Double){
        switch player {
            case .player1:
                if let value = UserDefaults.standard.object(forKey: "p1") {
                    UserDefaults.standard.set(value as! Double - by, forKey: "p1")
                }
                
            case .player2:
                if let value = UserDefaults.standard.object(forKey: "p2"){
                    UserDefaults.standard.set(value as! Double - by, forKey: "p2")
                }

        }
        
        UserDefaults.standard.synchronize()
    }
    
    
    
    func setHealth(player: Player, health: Double){
        switch player {
            case .player1:
                    UserDefaults.standard.set(health, forKey: "p1")
                
            case .player2:
                    UserDefaults.standard.set(health, forKey: "p2")
                

        }
        
        UserDefaults.standard.synchronize()
    }

    func getHealth(player: Player) -> Double {
        UserDefaults.standard.synchronize()
        
        switch player {
        case .player1:
            return UserDefaults.standard.double(forKey: "p1")
        case .player2:
            return UserDefaults.standard.double(forKey: "p2")
        }
    }
    
    func resetHealth(){
        UserDefaults.standard.set(100.0, forKey: "p1")
        UserDefaults.standard.set(100.0, forKey: "p2")
        
        UserDefaults.standard.synchronize()
    }

    
}
