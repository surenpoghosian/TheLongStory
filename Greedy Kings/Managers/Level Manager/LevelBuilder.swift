//
//  LevelBuilder.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 27.09.23.
//

import Foundation
import UIKit
import AVFoundation

final class LevelBuilder {
    private(set) var levels: [Level] = [
        Level(castleLeft: Castle(type: .wooden, locationOnScreen: .left, weapon: Weapon(type: .cannon, locationOnScreen: .left, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle1") , castleRight: Castle(type: .wooden, locationOnScreen: .right, weapon: Weapon(type: .cannon, locationOnScreen: .right, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle2"), obstacle:  Obstacle(type: .circle, difficulty: .easy, image: "Obstacle"), scene: Scene( image: "NormalScene1"), type: .normal),

        Level(castleLeft: Castle(type: .wooden, locationOnScreen: .left, weapon: Weapon(type: .cannon, locationOnScreen: .left, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle1") , castleRight: Castle(type: .wooden, locationOnScreen: .right, weapon: Weapon(type: .cannon, locationOnScreen: .right, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle2"), obstacle:  Obstacle(type: .circle, difficulty: .easy, image: "Obstacle"), scene: Scene( image: "NormalScene2"), type: .normal),

        Level(castleLeft: Castle(type: .wooden, locationOnScreen: .left, weapon: Weapon(type: .cannon, locationOnScreen: .left, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle1") , castleRight: Castle(type: .wooden, locationOnScreen: .right, weapon: Weapon(type: .cannon, locationOnScreen: .right, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle2"), obstacle:  Obstacle(type: .circle, difficulty: .easy, image: "Obstacle"), scene: Scene( image: "NormalScene3"), type: .normal),

        
        Level(castleLeft: Castle(type: .wooden, locationOnScreen: .left, weapon: Weapon(type: .cannon, locationOnScreen: .left, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle3") , castleRight: Castle(type: .wooden, locationOnScreen: .right, weapon: Weapon(type: .cannon, locationOnScreen: .right, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle4"), obstacle:  Obstacle(type: .circle, difficulty: .easy, image: "Obstacle"), scene: Scene( image: "HalloweenScene1"), type: .halloween),

        
        Level(castleLeft: Castle(type: .wooden, locationOnScreen: .left, weapon: Weapon(type: .cannon, locationOnScreen: .left, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle1") , castleRight: Castle(type: .wooden, locationOnScreen: .right, weapon: Weapon(type: .cannon, locationOnScreen: .right, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle4"), obstacle:  Obstacle(type: .circle, difficulty: .easy, image: "Obstacle"), scene: Scene( image: "SpaceScene1"), type: .space),

        Level(castleLeft: Castle(type: .wooden, locationOnScreen: .left, weapon: Weapon(type: .cannon, locationOnScreen: .left, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle1") , castleRight: Castle(type: .wooden, locationOnScreen: .right, weapon: Weapon(type: .cannon, locationOnScreen: .right, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle4"), obstacle:  Obstacle(type: .circle, difficulty: .easy, image: "Obstacle"), scene: Scene( image: "SpaceScene2"), type: .space),

        Level(castleLeft: Castle(type: .wooden, locationOnScreen: .left, weapon: Weapon(type: .cannon, locationOnScreen: .left, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle1") , castleRight: Castle(type: .wooden, locationOnScreen: .right, weapon: Weapon(type: .cannon, locationOnScreen: .right, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle4"), obstacle:  Obstacle(type: .circle, difficulty: .easy, image: "Obstacle"), scene: Scene( image: "SpaceScene3"), type: .space),

        Level(castleLeft: Castle(type: .wooden, locationOnScreen: .left, weapon: Weapon(type: .cannon, locationOnScreen: .left, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle1") , castleRight: Castle(type: .wooden, locationOnScreen: .right, weapon: Weapon(type: .cannon, locationOnScreen: .right, ammo: Ammo(type: .wood, image: "CannonBall"), image: "Cannon"), image: "Castle4"), obstacle:  Obstacle(type: .circle, difficulty: .easy, image: "Obstacle"), scene: Scene( image: "SpaceScene4"), type: .space),

    ]
    
//    private var adjustedLevel: Int = 0
    private var level: Int = 0

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

    
    init(type: LevelType) {
        if let randomLevelIndex = getRandomLevelIndex(forSceneType: type) {
            print("Randomly chosen level index for Halloween scene: \(randomLevelIndex)")
            self.level = randomLevelIndex
            self.initializeLevelComponents(level: randomLevelIndex)
        } else {
            print("No levels of the specified scene type found.")
        }
    }

    private func getRandomLevelIndex(forSceneType type: LevelType) -> Int? {
        let filteredLevels = levels.enumerated().filter { $0.element.type == type }
        
        if !filteredLevels.isEmpty {
            let randomIndex = Int.random(in: 0..<filteredLevels.count)
            return filteredLevels[randomIndex].offset
        } else {
            return nil
        }
    }

    
    private func initializeLevelComponents(level: Int){
        castleLeft = levels[level].castleLeft
        castleRight = levels[level].castleRight
        scene = levels[level].scene
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
        var x: CGFloat = 0
        var y: CGFloat = 0
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch castle.locationOnScreen {
        case .left:
            x = 20
            y = screenSize.height - 110
            width = 120
            height = 170
            
            component = UIView(frame: CGRect(x: x, y: y , width: width, height: height))
            component.backgroundColor = .clear
        case .right:
            x = screenSize.width - 90
            y = screenSize.height - 110
            width = 120
            height = 170

            
            component = UIView(frame: CGRect(x: x , y: y, width: width, height: height))
            component.backgroundColor = .clear
        }
        
        if let image = UIImage(named: castle.image) {
            addComponentImage(referenceView: component, image: image)
        }
        
        return component
    }
    
    private func createObstacle(obstacle: Obstacle) -> UIView {
        let x: CGFloat = screenSize.width / 2 - 40
        let y: CGFloat = screenSize.height / 2 - 40
        let width: CGFloat = 80
        let height: CGFloat = 80

        
        let component = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        component.backgroundColor = .blue
        
        if let image = UIImage(named: obstacle.image) {
            addComponentImage(referenceView: component, image: image)
        }
        return component
    }
    
    private func createWeapon(weapon: Weapon) -> UIView {
        var component: UIView!


        var x: CGFloat = 0
        var y: CGFloat = 0
        var width: CGFloat = 0
        var height: CGFloat = 0
        let angleInRadians = CGFloat(90).degreesToRadians
        
        
        switch weapon.locationOnScreen {
        case .left:
            x = 130
            y = screenSize.height - 100
            width = 40
            height = 70


            component = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
            component.backgroundColor = .clear
            component.transform = CGAffineTransform(rotationAngle: angleInRadians)
            if let image = UIImage(named: weapon.image) {
                addComponentImage(referenceView: component, image: image)
                
                let imageView = component.subviews[0]
                let imageViewOrigin = imageView.frame.origin
                imageView.transform = CGAffineTransform(rotationAngle: angleInRadians)
                
                let newFrame = CGRect(x: imageViewOrigin.x, y: imageViewOrigin.y, width: width, height: height)
                imageView.frame = newFrame
                
            }
        case .right:
            x = screenSize.width - 170
            y = screenSize.height - 100
            width = 40
            height = 70
            

            component = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
            component.backgroundColor = .clear
            component.transform = CGAffineTransform(rotationAngle: -angleInRadians)
            
            if let image = UIImage(named: weapon.image) {
                addComponentImage(referenceView: component, image: image)
                
                let imageView = component.subviews[0]
                let imageViewOrigin = imageView.frame.origin
                imageView.transform = CGAffineTransform(rotationAngle: angleInRadians)

                let newFrame = CGRect(x: imageViewOrigin.x, y: imageViewOrigin.y, width: width, height: height)
                imageView.frame = newFrame

            }
        }
        
        return component
    }
    
    private func createAmmo(weapon: Weapon, ammo: Ammo) -> UIView {
        var component: UIView!
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var width: CGFloat = 0
        var height: CGFloat = 0

        switch weapon.locationOnScreen {
        case .left:
            x = 130
            y = screenSize.height - 100
            width = 20
            height = 20

            component = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        case .right:
            x = screenSize.width - 170
            y = screenSize.height - 100
            width = 20
            height = 20
            
            component = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        }
        
        if let image = UIImage(named: ammo.image) {
            addComponentImage(referenceView: component, image: image)
        }
        
        component.backgroundColor = .clear
        
        return component
    }
    
    private func createScene(scene: Scene) -> UIView {
        let x: CGFloat = 0
        let y: CGFloat = 0
        let width: CGFloat = screenSize.width
        let height: CGFloat = screenSize.height

        
        let component = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        
        if let image = UIImage(named: scene.image) {
            addComponentImage(referenceView: component, image: image)
        }
        
        component.backgroundColor = .black
        
        
        return component
    }
    
    private func addComponentImage(referenceView: UIView, image: UIImage) {
        let imageView = UIImageView()

        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.frame = referenceView.bounds
        
        referenceView.addSubview(imageView)
    }
    
    func buildLevel(gameScene: UIView) -> UIView {
        let levelUI = buildLevelUI(gameScene: gameScene)
        let indicatingUI = buildIndicatingUI(referenceView: levelUI)
        let interactiveUI = buildInteractiveUI(referenceView: indicatingUI)
        
        return interactiveUI
    }
    
    //  function which builds level ui, castles, characters, obstacle, scene background etc.
    private func buildLevelUI(gameScene: UIView) -> UIView {
        let castleLeft = createCastle(castle: castleLeft)
        let castleRight = createCastle(castle: castleRight)
        let obstacle = createObstacle(obstacle: obstacle)
        let scene = createScene(scene: scene)
        let weaponLeft = createWeapon(weapon: castleLeftWeapon)
        let weaponRight = createWeapon(weapon: castleRightWeapon)
        let ammoLeft = createAmmo(weapon: castleLeftWeapon, ammo: castleLeftAmmo)
        let ammoRight = createAmmo(weapon: castleRightWeapon,ammo: castleRightAmmo)
        
        let components = [scene, castleLeft, castleRight, obstacle, weaponLeft, weaponRight, ammoLeft, ammoRight]
        
        for component in components {
            component.translatesAutoresizingMaskIntoConstraints = false
            gameScene.addSubview(component)
        }
        
        return gameScene
    }
    
    private func buildInteractiveUI(referenceView: UIView) -> UIView {
        let fullScreenView = UIView(frame: CGRect(x: 0, y: 0, width: referenceView.frame.width, height: referenceView.frame.height))
        fullScreenView.backgroundColor = UIColor.clear
        
        let pauseButton = createPauseButton()

        referenceView.addSubview(fullScreenView)
        referenceView.addSubview(pauseButton)
        
        
        return referenceView
    }
    
    private func createPlayerIndicatorView(side: Side) -> UIView {
        var componentX: Double = 0
        var componentY: Double = 0
        let componentWidth: Double = 310
        let componentHeight: Double = 80
        
        var characterImageViewX: Double = 0
        var characterImageViewY: Double = 0
        var characterImageViewWidth: Double = 60
        var characterImageViewHeight: Double = 60

        var characterBackgroundImageViewX: Double = 0
        var characterBackgroundImageViewY: Double = 0
        let characterBackgroundImageViewWidth: Double = 60
        let characterBackgroundImageViewHeight: Double = 60
        
        
        var healthScaleX: Double = 0
        var healthScaleY: Double = 0
        let healthScaleWidth: Double = 240
        let healthScaleHeight: Double = 30
        
        var healthScaleBackgroundX: Double = 0
        var healthScaleBackgroundY: Double = 0
        let healthScaleBackgroundWidth: Double = 250
        let healthScaleBackgroundHeight: Double = 50
        
        switch side {
        case .left:
            componentX = 20
            componentY = 10
            
            characterBackgroundImageViewX = componentX + 2
            characterBackgroundImageViewY = componentY - 5
            
            characterImageViewX = characterBackgroundImageViewX
            characterImageViewY = characterBackgroundImageViewY
            
            healthScaleBackgroundX = (characterBackgroundImageViewX + characterBackgroundImageViewWidth) - 3
            healthScaleBackgroundY = componentY
            
            healthScaleX = healthScaleBackgroundX
            healthScaleY = healthScaleBackgroundY + (healthScaleBackgroundHeight / 6)
            
        case .right:
            componentX = screenSize.width / 2 - componentWidth / 2 - 20
            componentY = 10
            
            healthScaleBackgroundX = componentX
            healthScaleBackgroundY = componentY
            
            healthScaleX = componentX + healthScaleBackgroundWidth - healthScaleWidth
            healthScaleY = healthScaleBackgroundY + (healthScaleBackgroundHeight / 6)
            
            characterBackgroundImageViewX = (healthScaleBackgroundX + healthScaleBackgroundWidth) - 2
            characterBackgroundImageViewY = componentY - 5
            
            characterImageViewX = characterBackgroundImageViewX
            characterImageViewY = componentY
        }
        
        
        characterImageViewWidth = characterBackgroundImageViewWidth * 0.7
        characterImageViewHeight = characterBackgroundImageViewHeight * 0.7
                
        let component = UIView(frame: CGRect(x: componentX, y: componentY, width: componentWidth, height: componentHeight))
        
        let characterBackgroundImageView = UIImageView(frame: CGRect(x: characterBackgroundImageViewX, y: characterBackgroundImageViewY, width: characterBackgroundImageViewWidth, height: characterBackgroundImageViewHeight))
        
        let characterImageView = UIImageView(frame: CGRect(x: characterBackgroundImageView.center.x - characterImageViewWidth / 2, y: characterBackgroundImageView.center.y - characterImageViewHeight / 2, width: characterImageViewWidth, height: characterImageViewHeight))

        let healthScaleBackground = UIImageView(frame: CGRect(x: healthScaleBackgroundX, y: healthScaleBackgroundY, width: healthScaleBackgroundWidth, height: healthScaleBackgroundHeight))
        
        let healthScale = UIView(frame: CGRect(x: healthScaleX, y: healthScaleY, width: healthScaleWidth, height: healthScaleHeight))
        
        component.backgroundColor = .clear
        
        characterBackgroundImageView.image = UIImage(named: "cellFrame")
        characterBackgroundImageView.contentMode = .scaleAspectFit
        
        characterImageView.contentMode = .scaleAspectFit
        characterImageView.backgroundColor = .clear

        healthScaleBackground.backgroundColor = UIColor(named: "backgroundColor")
        healthScale.backgroundColor = .systemBrown
        
        component.addSubview(characterBackgroundImageView)
        component.addSubview(characterImageView)
        component.addSubview(healthScaleBackground)
        component.addSubview(healthScale)
        
        

        switch side {
        case .left:
            healthScaleBackground.roundSpecificCorners(corners: [.topRight, .bottomRight], radius: 8)
        case .right:
            healthScaleBackground.roundSpecificCorners(corners: [.topLeft, .bottomLeft], radius: 8)
        }
        
        return component
    }
    
    func updatePlayerHealthIndicator(health: Double, referenceView: UIView, side: Side) {
        let percentageFraction = health / 100
        let originalFrame = referenceView.subviews[3].frame
        
        let newWidth = originalFrame.width * CGFloat(percentageFraction)
        
        var newX: Double = 0
        switch side {
        case .left:
            newX = originalFrame.origin.x
        case .right:
            newX = originalFrame.origin.x + (originalFrame.width * (CGFloat(1) -  CGFloat(percentageFraction)))
        }
        
        let newFrame = CGRect(x: newX, y: originalFrame.origin.y, width: newWidth, height: originalFrame.size.height)
        
        referenceView.subviews[3].frame = newFrame
    }
    
    private func createTimerLabel() -> UILabel {
        let timerLabelX = Int(screenSize.width / 2)
        let timerLabelY = 30
        let timerLabelWidth = 120
        let timerLabelHeight = 40
        
        let timerLabel = UILabel(frame: CGRect(x: timerLabelX - timerLabelWidth / 2, y: timerLabelY, width: timerLabelWidth, height: timerLabelHeight))
        
        timerLabel.textColor = .white
        
        timerLabel.font = UIFont.systemFont(ofSize: 45)
        timerLabel.text = ""
        timerLabel.textAlignment = .center
        
        return timerLabel
    }

    private func createPauseButton() -> UIButton {
        let buttonX = Int(screenSize.width / 2)
        let buttonY = 30
        let buttonWidth = 40
        let buttonHeight = 40
        
        let button = UIButton(frame: CGRect(x: buttonX + buttonWidth + 10, y: buttonY, width: buttonWidth, height: buttonHeight))
        
        if let image = UIImage(named: "pause") {
            button.setImage(image, for: .normal)
        }
        
        
        return button
    }

    
    
    private func buildIndicatingUI(referenceView: UIView) -> UIView {
        let leftPlayerIndicator = createPlayerIndicatorView(side: .left)
        let rightPlayerIndicator = createPlayerIndicatorView(side: .right)
        let timerLabel = createTimerLabel()
        
        referenceView.addSubview(leftPlayerIndicator)
        referenceView.addSubview(rightPlayerIndicator)
        referenceView.addSubview(timerLabel)
        
        return referenceView
    }
    
    func updateAmmoLocation(for weapon: UIView ,ammo: UIView) {
        let newX = weapon.frame.origin.x + weapon.frame.width - ammo.frame.width
        let newY = weapon.frame.origin.y + ammo.frame.height
        
        self.physicsManager.updtateItemPosition(item: ammo, toX: newX, toY: newY)
    }
    
    
    func updateAmmoVisiblity(for ammo: UIView, isHidden: Bool) {
        ammo.isHidden = isHidden
    }
    
    deinit {
        print("level builder deinit")
    }
    
}
