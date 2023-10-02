//
//  PickPlayerModels.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 27.09.23.
//

import Foundation
import UIKit

struct Character {
    var name: String
    var avatar: UIImage
    var availableToPick: Bool = true
}

enum PlayerRole {
    case player1
    case player2
}
