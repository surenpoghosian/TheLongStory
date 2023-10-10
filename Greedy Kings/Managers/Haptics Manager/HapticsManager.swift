//
//  HapticsManager.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 10.10.23.
//

import Foundation
import UIKit

final class HapticsManager {
    private var generator: UIImpactFeedbackGenerator!
    private var complexGenerator:UINotificationFeedbackGenerator!
    
    
    init(generator: UIImpactFeedbackGenerator!, complexGenerator: UINotificationFeedbackGenerator!) {
        self.generator = generator
        self.complexGenerator = complexGenerator
        initializeComplexGenerator()
    }
    
    private func initializeComplexGenerator(){
        complexGenerator = UINotificationFeedbackGenerator()
        complexGenerator.prepare()
    }
    
    func generate(type: HapticType){
        switch type {
        case .light:
            generator = UIImpactFeedbackGenerator(style: .light)
        case .medium:
            generator = UIImpactFeedbackGenerator(style: .medium)
        case .heavy:
            generator = UIImpactFeedbackGenerator(style: .heavy)
        case .success:
            complexGenerator.notificationOccurred(.success)
        case .fail:
            complexGenerator.notificationOccurred(.error)

        }
    }
}
