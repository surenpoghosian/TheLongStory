//
//  CGFloat.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 08.10.23.
//

import Foundation


extension CGFloat {
    var degreesToRadians: CGFloat {
        return self * .pi / 180.0
    }
    
    var radiansToDegrees: CGFloat {
        return self * 180.0 / .pi
    }
}

