//
//  LevelModel.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 27.09.23.
//

import Foundation


// Castle and its parameters
struct Castle {
    var locationOnScreen: ScreenSide
    var health: Double = 100.0
    var weapon: Weapon
}

// Weapon and its parameters
struct Weapon {
    var ammo: Ammo
}

// Ammo shot by weapon
struct Ammo {
    
}

// An obstacle which will be located between the castles, at the center, and will define the difficulty of the level
struct Obstacle {
    var type: ObstacleType
    var difficulty: Difficulty
}

// Obstacle types. It may be a square, circle etc.
enum ObstacleType{
    case rectangle
    case circle
    case triangle
    case square
    case wall
}

// Enum which defines on which side of the screen castle is located, left or right
enum ScreenSide {
    case left
    case right
}

// Enum which represents background and theme of the scene
enum SceneType {
    case spring
    case summer
    case autumn
    case winter
}

// Level struct which combines all level components
struct Level {
    var castleLeft: Castle
    var castleRight: Castle
    var obstacle: Obstacle
    var sceneType: SceneType
}

// Enum for obstacle dificulty definiiton, each have 3 stages easy, medium, hard, which defines their size
enum Difficulty {
    case easy
    case medium
    case hard
}
