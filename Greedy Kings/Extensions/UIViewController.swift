//
//  UIViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 16.10.23.
//

import UIKit



extension UIViewController {
    var topMostPresentedViewController: UIViewController {
        if let presenting = presentingViewController {
            return presenting.topMostPresentedViewController
        }
        
        return self
    }
    
    func show(viewController: UIViewController, animated: Bool) {
        if let navigationController {
            navigationController.pushViewController(viewController, animated: animated)
        } else {
            present(viewController, animated: animated)
        }
    }
    
    func dismissToRoot(animated: Bool) {
        if let navigationController {
            navigationController.popToRootViewController(animated: animated)
        } else {
            topMostPresentedViewController.dismiss(animated: true)
        }
    }
}
