//
//  GameModels.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 04.10.23.
//

import Foundation

enum Player: Codable {
    case player1
    case player2
}

struct BattleResult {
    var player1Shots: Int
    var player1Hits: Int
    var player2Shots: Int
    var player2Hits: Int
    var winner: Player?
}

struct BattleModel: Codable {
    var player1Character: Character
    var player1Health: Double
    
    var player2Character: Character
    var player2Health: Double
    
    var turn: Player
}
