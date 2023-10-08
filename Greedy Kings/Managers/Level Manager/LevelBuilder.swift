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
        Level(castleLeft: Castle(type: .wooden, locationOnScreen: .left, weapon: Weapon(type: .cannon, locationOnScreen: .left, ammo: Ammo(type: .wood))) , castleRight: Castle(type: .wooden, locationOnScreen: .right, weapon: Weapon(type: .cannon, locationOnScreen: .right, ammo: Ammo(type: .wood))), obstacle:  Obstacle(type: .circle, difficulty: .easy), sceneType: .autumn)
    ]
    
    private var adjustedLevel: Int = 0
    var level: Int = 0 {
        willSet(newValue) {
            adjustedLevel = newValue - 1
        }
    }
    
    private var castleLeft: Castle!
    private var castleRight: Castle!
    private var scene: Scene!
    private var obstacle: Obstacle!
    private var castleLeftWeapon: Weapon!
    private var castleRightWeapon: Weapon!
    private var castleLeftAmmo: Ammo!
    private var castleRightAmmo: Ammo!
    private let screenSize = UIScreen.main.bounds
    var physicsManager: PhysicsManager!
    
    
    init(level: Int) {
        self.level = level
        self.initializeLevelComponents(level: adjustedLevel)
    }

    
    private func initializeLevelComponents(level: Int){
        castleLeft = levels[level].castleLeft
        castleRight = levels[level].castleRight
        scene = levels[level].sceneType
        obstacle = levels[level].obstacle
        castleLeftWeapon = levels[level].castleLeft.weapon
        castleRightWeapon = levels[level].castleRight.weapon
        castleLeftAmmo = levels[level].castleLeft.weapon.ammo
        castleRightAmmo = levels[level].castleRight.weapon.ammo
    }

    func initializePhysicsBehavior(parentView: UIView){
        self.physicsManager = PhysicsManager(parentView: parentView)
    }
    
    private func createCastle(castle: Castle) -> UIView {
        var component: UIView!

        switch castle.locationOnScreen {
        case .left:
            component = UIView(frame: CGRect(x: 20, y: screenSize.height - 110 , width: 90, height: 90))
            component.backgroundColor = .red
        case .right:
            component = UIView(frame: CGRect(x: screenSize.width - 110 , y: screenSize.height - 110, width: 90, height: 90))
            component.backgroundColor = .cyan
        }
        return component
    }

    private func createObstacle(obstacle: Obstacle) -> UIView {
        let component = UIView(frame: CGRect(x: screenSize.width / 2 - 40, y: screenSize.height / 2 - 40 , width: 80, height: 80))
        component.backgroundColor = .blue
        return component
    }

    private func createWeapon(weapon: Weapon) -> UIView {
        var component: UIView!
        let angleInRadians = CGFloat(90).degreesToRadians
        
        switch weapon.locationOnScreen {
        case .left:
            component = UIView(frame: CGRect(x: 90, y: screenSize.height - 140, width: 40, height: 70))
            component.backgroundColor = .yellow
            component.transform = CGAffineTransform(rotationAngle: angleInRadians)
        case .right:
            component = UIView(frame: CGRect(x: screenSize.width - 130, y: screenSize.height - 140, width: 40, height: 70))
            component.backgroundColor = .green
            component.transform = CGAffineTransform(rotationAngle: -angleInRadians)
        }

        return component
    }
    
    private func createAmmo(weapon: Weapon, ammo: Ammo) -> UIView {
        var component: UIView!
        
        switch weapon.locationOnScreen {
        case .left:
            component = UIView(frame: CGRect(x: 90, y: screenSize.height - 140, width: 20, height: 20))
        case .right:
            component = UIView(frame: CGRect(x: screenSize.width - 90, y: screenSize.height - 140, width: 20, height: 20))
        }
        component.backgroundColor = .orange

        return component
    }
    
    private func createScene(scene: Scene) -> UIView {
        let component = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        component.backgroundColor = .black
        return component
    }

    func buildLevel(gameScene: UIView) -> UIView {
        let levelUI = self.buildLevelUI(gameScene: gameScene)
        let interactiveUI = self.buildInteractiveUI(gameScene: levelUI)

        return interactiveUI
    }
    
//  function which builds level ui, castles, characters, obstacle, scene background etc.
    private func buildLevelUI(gameScene: UIView) -> UIView {
        let castleLeft = createCastle(castle: castleLeft)
        let castleRight = createCastle(castle: castleRight)
        let obstacle = createObstacle(obstacle: obstacle)
        let scene = createScene(scene: scene)
        
        
        let components = [scene, castleLeft, castleRight, obstacle]
        
        for component in components {
            component.translatesAutoresizingMaskIntoConstraints = false
            gameScene.addSubview(component)
        }
        
        return gameScene
    }
    
//  function which builds user interactive components, weapons, ammo, game control elements
    private func buildInteractiveUI(gameScene: UIView) -> UIView {
        var gameScene = gameScene
        
        var weaponLeft = createWeapon(weapon: castleLeftWeapon)
        var weaponRight = createWeapon(weapon: castleRightWeapon)
        var ammoLeft = createAmmo(weapon: castleLeftWeapon, ammo: castleLeftAmmo)
        var ammoRight = createAmmo(weapon: castleRightWeapon,ammo: castleRightAmmo)
        
        let components = [weaponLeft, weaponRight, ammoLeft, ammoRight]
        
        for component in components {
            component.translatesAutoresizingMaskIntoConstraints = false
            gameScene.addSubview(component)
        }

        setupUserInteractiveUIConstraints(weaponLeft: &weaponLeft, weaponRight: &weaponRight, ammoLeft: &ammoLeft, ammoRight: &ammoRight, gameScene: &gameScene)

        return gameScene
    }
        
    
    func setupUserInteractiveUIConstraints( weaponLeft: inout UIView, weaponRight: inout UIView, ammoLeft: inout UIView, ammoRight: inout UIView, gameScene: inout UIView){
        NSLayoutConstraint.activate([
            
        ])
        
        NSLayoutConstraint.activate([

        ])

        NSLayoutConstraint.activate([

        ])

        NSLayoutConstraint.activate([

        ])
        
        NSLayoutConstraint.activate([

        ])

        NSLayoutConstraint.activate([
            
        ])
    }
      
//    func updateAmmoLocation(locationOnScreen: ScreenSide, ammoView: UIView) {
//        switch locationOnScreen {
//        case .left:
//            let newX: CGFloat = 90.0
//            let newY: CGFloat = screenSize.height - 140.0
//            self.physicsManager.updtateItemPosition(item: ammoView, toX: newX, toY: newY)
//        case .right:
//            let newX: CGFloat = screenSize.width - 90.0
//            let newY: CGFloat = screenSize.height - 140.0
//            self.physicsManager.updtateItemPosition(item: ammoView, toX: newX, toY: newY)
//        }
//    }

    func updateAmmoLocation(originX newX: CGFloat, originY newY: CGFloat, ammoView: UIView) {
        self.physicsManager.updtateItemPosition(item: ammoView, toX: newX, toY: newY)
    }

    
}
