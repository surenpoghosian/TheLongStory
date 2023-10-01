//
//  LevelModel.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 27.09.23.
//

import Foundation
import UIKit




// Castle and its parameters
struct Castle {
    var type: CastleType
    var locationOnScreen: ScreenSide
    var weapon: Weapon
    var health: Double = 100.0
}

// Weapon and its parameters
struct Weapon {
    var type: WeaponType
    var locationOnScreen: ScreenSide
    var ammo: Ammo
}

// Ammo shot by weapon
struct Ammo {
    var type: AmmoType
}

// An obstacle which will be located between the castles, at the center, and will define the difficulty of the level
struct Obstacle {
    var type: ObstacleType
    var difficulty: Difficulty
}

// Level struct which combines all level components
struct Level {
    var castleLeft: Castle
    var castleRight: Castle
    var obstacle: Obstacle
    var sceneType: Scene
}

// Obstacle types. It may be a square, circle etc.
enum ObstacleType{
    case rectangle
    case circle
    case triangle
    case square
    case romb
    case wall
}

// weapons that can be attached to castle
enum WeaponType {
    case cannon
}

// castle type, it'll affect to health
enum CastleType {
    case wooden
    case stone
    case iron
}

// ammo types, with different damage
enum AmmoType {
    case wood
    case stone
    case iron
}

// Enum which defines on which side of the screen castle is located, left or right
enum ScreenSide {
    case left
    case right
}

// Enum which represents background and theme of the scene
enum Scene {
    case spring
    case summer
    case autumn
    case winter
}

// Enum for obstacle dificulty definiiton, each have 3 stages easy, medium, hard, which defines their size
enum Difficulty {
    case easy
    case medium
    case hard
}
