//
//  UIView.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 17.10.23.
//

import UIKit


extension UIView {
    func roundSpecificCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = maskPath.cgPath
        
        layer.mask = shapeLayer
    }
}
