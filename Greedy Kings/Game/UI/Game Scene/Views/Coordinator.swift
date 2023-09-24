//
//  Coordinator.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 24.09.23.
//

import UIKit

final class Coordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func pushViewController<T: UIViewController>(identifier: String, viewControllerType: T.Type) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T {
            navigationController.pushViewController(vc, animated: true)
        }
    }
}
