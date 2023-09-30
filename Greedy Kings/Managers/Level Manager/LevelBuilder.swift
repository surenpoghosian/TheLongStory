//
//  LevelBuilder.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 27.09.23.
//

import Foundation
import UIKit


final class LevelBuilder {
    private var levels: [Level] = [
        Level(castleLeft: Castle(locationOnScreen: .left, weapon: Weapon(ammo: Ammo())), castleRight: Castle(locationOnScreen: .right, weapon: Weapon(ammo: Ammo())), obstacle: Obstacle(type: .circle, difficulty: .easy), sceneType: .summer)
    ]
    
    var level: Int = 0 {
        willSet(newValue) {
            adjustedLevel = newValue - 1
        }
    }
    private var adjustedLevel: Int = 0
    
    private var castleLeft: Castle!
    private var castleRight: Castle!
    private var sceneType: SceneType!
    private var obstacle: Obstacle!

    
    init(level: Int) {
        self.level = level
        self.initializeLevelComponents(level: adjustedLevel)
    }
    
    private func initializeLevelComponents(level: Int){
        castleLeft = levels[level].castleLeft
        castleRight = levels[level].castleRight
        obstacle = levels[level].obstacle
        sceneType = levels[level].sceneType
    }

    func setupUIElementsOnScreen(){
//        castleLeft
        NSLayoutConstraint.activate([

        ])

//        castleRight
        NSLayoutConstraint.activate([

        ])

//        obstacle
        NSLayoutConstraint.activate([

        ])

// Scene background / SceneType
        NSLayoutConstraint.activate([

        ])




    }
    
//  function which builds level ui, castles, characters, obstacle, scene background etc.
    func buildLevelUI(containerView: UIView) -> UIView {


        return UIView()
    }
    
//  function which builds user interactive components, weapons, ammo, game control elements
    func buildUserInteractiveUI(containerView: UIView) -> UIView {
        
        
        return UIView()
    }
    
}
