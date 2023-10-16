//
//  AnimationModels.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 15.10.23.
//

import Foundation
import Lottie
import UIKit

final class Animation {
    private(set) var animationView: LottieAnimationView?
    
    func play(x: CGFloat, y: CGFloat, type: AnimationType, referenceView: UIView){
        switch type {
        case .hit:
            let animations = ["animation3"]
            animate(x: x, y: y, type: .hit, animations: animations, speed: 3, referenceView: referenceView, removeOnFinish: true)
        case .miss:
            let animations = ["animation3"]
            animate(x: x, y: y, type: .miss, animations: animations, speed: 3, referenceView: referenceView, removeOnFinish: true)
        case .shot:
            let animations = ["animation4"]
            animate(x: x, y: y, type: .shot, animations: animations, speed: 5, referenceView: referenceView, removeOnFinish: true)
        case .strength:
            let animations = ["animation2"]
            animate(x: x, y: y, type: .strength, animations: animations, speed: 5, referenceView: referenceView, removeOnFinish: false)
        }
    }
    
    func stop(referenceView: UIView, animationView: LottieAnimationView){
        self.removeAnimation(referenceView: referenceView, child: animationView)
    }
    
    private func animate(x: CGFloat, y: CGFloat, type: AnimationType, animations:[String], speed: CGFloat, referenceView: UIView, removeOnFinish: Bool){
        let shotAnimations = animations
        let animationName = shotAnimations.randomElement()
        if let animationName {
            animationView = createAnimationView(x: x, y: y, name: animationName, type: type, speed: speed)
            if let animationView {
                referenceView.addSubview(animationView)
                animationView.play() { finished in
                    if removeOnFinish {
                        self.removeAnimation(referenceView: referenceView, child: animationView)
                    }
                }
            }
            
        } else {
            print("animation Not Found")
        }
    }
    
    private func createAnimationView(x: CGFloat, y: CGFloat, name: String , type: AnimationType, speed: CGFloat) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        var animationViewWidth = CGFloat(100)
        var animationViewHeight = CGFloat(100)
        var animationViewX = CGFloat(0)
        var animationViewY = CGFloat(0)
        
        switch type {
        case .hit:
            let point = CGPoint(x: x, y: y)
            let side = detectSideOfScreen(coordinate: point)
            
            switch side {
            case .left:
                animationViewX = CGFloat(x + animationViewWidth / 2)
                animationViewY = CGFloat(y - animationViewHeight / 2)
            case .right:
                animationViewX = CGFloat(x - animationViewWidth / 2)
                animationViewY = CGFloat(y - animationViewHeight / 2)
            }
            
        case .shot:
            let point = CGPoint(x: x, y: y)
            let side = detectSideOfScreen(coordinate: point)
            
            switch side {
            case .left:
                animationViewX = CGFloat(x + animationViewWidth / 2)
                animationViewY = CGFloat(y - animationViewWidth / 2)
            case .right:
                animationViewX = CGFloat(x - animationViewWidth / 2)
                animationViewY = CGFloat(y - animationViewWidth / 2)
            }
            
        case .miss:
            animationViewX = CGFloat(x - animationViewWidth / 2)
            animationViewY = CGFloat(y - animationViewWidth / 2)
            
        case .strength:
            animationViewWidth = 300
            animationViewHeight = 100
            animationView.tag = 96
            animationViewX = CGFloat(x - animationViewWidth / 2)
            animationViewY = CGFloat(y - animationViewHeight)
        }
        
        
        let animationViewSize = CGRect(x: animationViewX, y: animationViewY, width: animationViewWidth, height: animationViewHeight)
        animationView.frame = animationViewSize
        
        animationView.loopMode = .playOnce
        animationView.animationSpeed = speed
        return animationView
    }
    
    
    private func removeAnimation(referenceView: UIView, child: LottieAnimationView) {
        if child.isDescendant(of: referenceView) {
            child.removeFromSuperview()
        }
    }
    
    private func detectSideOfScreen(coordinate: CGPoint) -> Side {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenCenterX = screenWidth / 2.0
        
        if coordinate.x < screenCenterX {
            return .left
        } else {
            return .right
        }
    }
    
}


enum AnimationType {
    case hit
    case miss
    case shot
    case strength
}





