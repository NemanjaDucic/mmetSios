//
//  AppUtility.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 17.4.24..
//

import Foundation
import UIKit
struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
         let size = image.size
         
         let widthRatio  = targetSize.width  / size.width
         let heightRatio = targetSize.height / size.height
         
         // Figure out what our orientation is, and use that to form the rectangle
         var newSize: CGSize
         if widthRatio > heightRatio {
             newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
         } else {
             newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
         }
         
         // This is the rect that we've calculated out and this is what is actually used below
         let rect = CGRect(origin: .zero, size: newSize)
         
         // Actually do the resizing to the rect using the ImageContext stuff
         UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
         image.draw(in: rect)
         let newImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         
         return newImage!
     }

}
