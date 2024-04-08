//
//  OnboardingViewCoontrollerMain.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 10.3.23..
//

import Foundation
import UIKit

protocol PageViewDelegate: AnyObject {
    func updatePageViewController()
}
class OnboardingViewControllerMain :UIViewController{
    
    
    weak var nDelegate: PageViewDelegate?


    @IBOutlet weak var container: UIView!

    @IBOutlet weak var buttonNext: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.08),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.bounds.width * 0.08),
            container.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1),
            container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.66),
            buttonNext.leadingAnchor.constraint(equalTo: container.leadingAnchor,constant: view.bounds.width * 0.3),
            container.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -view.bounds.width * 0.3)
        ])
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
       nDelegate?.updatePageViewController()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "nameOfNotification"), object: nil)

    }

}
