//
//  PhysicsManager.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 02.10.23.
//

import Foundation
import UIKit

final class PhysicsManager: NSObject {
    var animator: UIDynamicAnimator!
    private var gravityBehavior: UIGravityBehavior!
    private var pushBehavior: UIPushBehavior!
    var collisionBehavior: UICollisionBehavior!

    init(parentView: UIView!) {
        super.init()
        initializeAllBehaviors()
        initializeAnimator(referenceView: parentView)
        
//        It'll be right and perfect to move the part below outside of the PhysicsManager
        initializeItem(item: parentView.subviews[1], weight: 3000, applyGravity: true)
        initializeItem(item: parentView.subviews[2], weight: 3000, applyGravity: true)
        initializeItem(item: parentView.subviews[3], weight: 1500.0, applyGravity: false)
        initializeItem(item: parentView.subviews[6], weight: 3, applyGravity: true)
        initializeItem(item: parentView.subviews[7], weight: 3, applyGravity: true)
        
    }
    
    private func initializeAnimator(referenceView: UIView){
        self.animator = UIDynamicAnimator(referenceView: referenceView)
        self.animator.addBehavior(gravityBehavior)
        self.animator.addBehavior(collisionBehavior)
    }
    
    func initializeItem(item: UIView, weight: Double, applyGravity: Bool = true) {
        let itemBehavior = self.addDynamicItemBehavior(view: item, weight: weight)
        self.addCollisionBehavior(view: item)
        
        if applyGravity {
            self.addGravityBehavior(view: item)
        }

        
        self.animator.addBehavior(itemBehavior)
    }
    
    private func initializeAllBehaviors(){
        initializeGravityBehavior()
        initializeCollisionBehavior()
    }

    private func initializeGravityBehavior(){
        self.gravityBehavior = UIGravityBehavior(items: [])
        self.gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 1)
    }
    
    private func initializePushBehavior(){
        pushBehavior = UIPushBehavior(items: [], mode: .instantaneous)
    }

    private func initializeCollisionBehavior(){
        self.collisionBehavior = UICollisionBehavior(items: [])
    }

    func removeBehaviors(){
        self.animator.removeBehavior(gravityBehavior)
    }
        
    func addCollisionBehavior(view: UIView) {
        self.collisionBehavior.addItem(view)
        self.collisionBehavior.translatesReferenceBoundsIntoBoundary = true
    }
    
    func addGravityBehavior(view: UIView) {
        self.gravityBehavior.addItem(view)
    }
    
    private func addDynamicItemBehavior(view: UIView, weight: Double) -> UIDynamicItemBehavior {
        let item = UIDynamicItemBehavior(items: [view])
        item.density = weight
        return item
    }
    
    func getAnimator() -> UIDynamicAnimator {
        return self.animator
    }
    
    func removeGravityBehavior(from item: UIView) {
        self.gravityBehavior.removeItem(item)
    }
    
    func removeCollisionBehavior(from item: UIView){
        self.collisionBehavior.removeItem(item)
    }
    
    func shot(item: UIView, from cannon: UIView, toSide: Side, strength: Double) {
        let cannonCenter = cannon.center
        let ammoCenter = item.center
        let dx = Double(ammoCenter.x - cannonCenter.x)
        let dy = Double(ammoCenter.y - cannonCenter.y)

        let magnitude = sqrt(dx * dx + dy * dy)

        let directionX = dx / magnitude
        let directionY = dy / magnitude
        
        switch toSide {
        case .left:
            pushBehavior = UIPushBehavior(items: [item], mode: .instantaneous)
            pushBehavior.pushDirection = CGVector(dx: -directionX * strength, dy: directionY * strength)
            animator.addBehavior(pushBehavior)
        case .right:
            pushBehavior = UIPushBehavior(items: [item], mode: .instantaneous)
            pushBehavior.pushDirection = CGVector(dx: directionX * strength, dy: directionY * strength)
            animator.addBehavior(pushBehavior)
        }
    }

    
    func updtateItemPosition(item: UIView, toX: CGFloat, toY: CGFloat){
        item.center = CGPoint(x: toX, y: toY)
        self.animator.updateItem(usingCurrentState: item)
    }
            
}


