//
//  PickPlayerModels.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 27.09.23.
//

import Foundation
import UIKit

struct Character: Codable {
    var name: String
    var avatarID: String
    var availableToPick: Bool = true
}

struct PickedCharacters: Codable {
    var player1Character: Character
    var player2Character: Character
}

enum PlayerRole {
    case player1
    case player2
}
