//
//  UIImage.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 20.10.23.
//

import UIKit


extension UIImage {
    func applyBlur(radius: CGFloat) -> UIImage? {
        let context = CIContext(options: nil)
        if let currentFilter = CIFilter(name: "CIGaussianBlur") {
            currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
            currentFilter.setValue(radius, forKey: kCIInputRadiusKey)
            if let output = currentFilter.outputImage {
                if let cgimg = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgimg)
                }
            }
        }
        return nil
    }
}
