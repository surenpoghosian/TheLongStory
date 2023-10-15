import Foundation
import UIKit

final class HapticsManager {
    private var generator: UIImpactFeedbackGenerator
    private var complexGenerator: UINotificationFeedbackGenerator

    init() {
        generator = UIImpactFeedbackGenerator()
        complexGenerator = UINotificationFeedbackGenerator()
        complexGenerator.prepare()
    }

    func generate(type: HapticType) {
        generator.prepare()
        generator.impactOccurred()

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
