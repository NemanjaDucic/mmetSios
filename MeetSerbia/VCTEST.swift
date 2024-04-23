//
//  VCTEST.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 12.4.24..
//

import Foundation
import UIKit
import ImageScrollView
import FirebaseDatabase
import FloatingTabBarController



class VCTEST:FloatingTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        floatingTabBarController?.scrollView.isScrollEnabled = false
        // Replace the instantiation of view controllers with your own identifiers
        
      
        let identifiers = ["TravelVC", "HomeVC", "ProfileVC"]
        let selectedImageNames = ["pin", "nature_pin", "sports_pin"]
        let normalImageNames = ["pin", "pin", "pin"]
         viewControllers = (1...3).map { "\($0)" }.enumerated().map { index, tabName in
            let controller = storyboard!.instantiateViewController(withIdentifier: identifiers[index])
            controller.title = tabName
            controller.view.backgroundColor = UIColor(named: tabName)
            controller.floatingTabItem = FloatingTabItem(selectedImage: UIImage(named: selectedImageNames[index])!, normalImage: UIImage(named: normalImageNames[index])!)
            return controller
        }
    }
    
}
