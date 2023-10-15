//
//  Models.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 22.09.23.
//

import Foundation
import Lottie
import UIKit

final class Animation {
    private(set) var animationView: LottieAnimationView?
    
    func play(x: CGFloat, y: CGFloat, type: AnimationType, referenceView: UIView){
        switch type {
        case .hit:
            let animations = ["animation1", "animation2", "animation3"]
            animate(x: x, y: y, animations: animations, referenceView: referenceView)
        case .miss:
            let animations = ["animation1", "animation2", "animation3"]
            animate(x: x, y: y, animations: animations, referenceView: referenceView)
        case .shot:
            let animations = ["animation1", "animation2", "animation3"]
            animate(x: x, y: y, animations: animations, referenceView: referenceView)
            
        }
        
    }
    
    private func animate(x: CGFloat, y: CGFloat, animations:[String], referenceView: UIView){
        let shotAnimations = animations
        let animationName = shotAnimations.randomElement()
        if let animationName {
            animationView = createAnimationView(x: x, y: y, name: animationName, speed: 3)
            if let animationView {
                referenceView.addSubview(animationView)
                animationView.play() { finished in
                    self.removeAnimation(referenceView: referenceView, child: animationView)
                }
            }

        } else {
            print("animation Not Found")
        }
    }
    
    private func createAnimationView(x: CGFloat, y: CGFloat, name: String, speed: CGFloat) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: name)
        let animationViewSize = CGRect(x: x, y: y, width: 100, height: 100)
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

}


enum AnimationType {
    case hit
    case miss
    case shot
}





