//
//  AddNewMemmoryNavigation.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 13.3.23..
//

import Foundation
import UIKit
class AddNewMemmoryNavigation:UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
    }
}
