//
//  root.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 10.3.23..
//

import Foundation
import UIKit
class RootViewController: UIViewController,PageViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myPageViewController = MyPageViewController()
        addChild(myPageViewController)
        view.addSubview(myPageViewController.view)
        myPageViewController.didMove(toParent: self)
        if let  vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onbord") as? OnboardingViewControllerMain{
             vc.nDelegate = self
         }
    }
    func updatePageViewController() {
        print("zz")
    }
}
