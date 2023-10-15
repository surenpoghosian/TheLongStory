//
//  GameModels.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 04.10.23.
//

import Foundation

enum Player {
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
