//
//  PhysicsManager.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 02.10.23.
//

import Foundation
import UIKit

final class PhysicsManager {
    private var animator: UIDynamicAnimator!
    private var collisionBehavior: UICollisionBehavior!
    private var gravityBehavior: UIGravityBehavior!
    private var pushBehavior: UIPushBehavior!
    
    init(parentView: UIView!) {
        initializeAllBehaviors()
        initializeAnimator(referenceView: parentView)
    }
    
    private func initializeAnimator(referenceView: UIView){
        self.animator = UIDynamicAnimator(referenceView: referenceView)
        self.animator.addBehavior(gravityBehavior)
        self.animator.addBehavior(collisionBehavior)
        
        for item in 1..<referenceView.subviews.count {
            initializeItem(item: referenceView.subviews[item])
        }
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

    private func initializeAllBehaviors(){
        initializeGravityBehavior()
        initializeCollisionBehavior()
    }
    
    func initializeItem(item: UIView) {
        let itemBehavior = self.addDynamicItemBehavior(view: item, weight: 2.0)
        self.addCollisionBehavior(view: item)
        self.addGravityBehavior(view: item)
        self.animator.addBehavior(itemBehavior)
    }
    
    private func addCollisionBehavior(view: UIView) {
        self.collisionBehavior.addItem(view)
        self.collisionBehavior.translatesReferenceBoundsIntoBoundary = true
    }
    
    private func addGravityBehavior(view: UIView) {
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
    
    func shotFromLeft(item: UIView){
        let velocity = CGPoint(x: -2200.0, y: -500.0)
        pushBehavior = UIPushBehavior(items: [item], mode: .instantaneous)
        pushBehavior.pushDirection = CGVector(dx: velocity.x / 200, dy: velocity.y / 200)
        animator.addBehavior(pushBehavior)
    }
        
}


