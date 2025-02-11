//
//  UIImage+Extension.swift
//  DevExamUikit
//
//  Created by balamuruganc on 11/02/25.
//

import UIKit

extension UIImage {
    /// Returns a new image rotated by the specified angle (in radians).
    func rotated(by radians: CGFloat) -> UIImage? {
        // Calculate the new image's size.
        var newSize = CGRect(origin: .zero, size: self.size)
            .applying(CGAffineTransform(rotationAngle: radians)).integral.size
        
        // Create a graphics context with the new size.
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Move the origin to the middle so the rotation happens around the center.
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        // Rotate the context.
        context.rotate(by: radians)
        // Draw the image into the context.
        self.draw(in: CGRect(x: -self.size.width / 2,
                             y: -self.size.height / 2,
                             width: self.size.width,
                             height: self.size.height))
        
        // Retrieve the rotated image.
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotatedImage
    }
}
