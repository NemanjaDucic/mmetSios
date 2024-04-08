//
//  othertest.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 7.3.23..
//

import Foundation
import UIKit
class MyTestViewController: UIViewController {

    let myContainerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .gray
        return v
    }()

    var thePageVC: MyPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
     
        // add myContainerView
        view.addSubview(myContainerView)

        // constrain it - here I am setting it to
        //  40-pts top, leading and trailing
        //  and 200-pts height
        NSLayoutConstraint.activate([
            myContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40.0),
            myContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40.0),
            myContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40.0),
            myContainerView.heightAnchor.constraint(equalToConstant: 200),
            ])

        // instantiate MyPageViewController and add it as a Child View Controller
        thePageVC = MyPageViewController()
        addChild(thePageVC)

        // we need to re-size the page view controller's view to fit our container view
        thePageVC.view.translatesAutoresizingMaskIntoConstraints = false

        // add the page VC's view to our container view
        myContainerView.addSubview(thePageVC.view)

        // constrain it to all 4 sides
        NSLayoutConstraint.activate([
            thePageVC.view.topAnchor.constraint(equalTo: myContainerView.topAnchor, constant: 50),
            thePageVC.view.bottomAnchor.constraint(equalTo: myContainerView.bottomAnchor, constant: 0.0),
            thePageVC.view.leadingAnchor.constraint(equalTo: myContainerView.leadingAnchor, constant: 0.0),
            thePageVC.view.trailingAnchor.constraint(equalTo: myContainerView.trailingAnchor, constant: 0.0),
            ])

        thePageVC.didMove(toParent: self)
    }

}
