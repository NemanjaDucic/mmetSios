//
//  OnboardingViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 10.3.23..
//

import Foundation
import UIKit
import SwiftyGif

class Slide1ViewController: UIViewController,PageViewDelegate {
    @IBOutlet weak var imageLogogif: UIImageView!
    func updatePageViewController() {
        print("zzzzzzzzzzzzzz")
    }
    

    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let  vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "onbord") as? OnboardingViewControllerMain{
             vc.nDelegate = self
         }
      uiSetup()
    }
    private func uiSetup(){
        do {
            let gif = try UIImage(gifName: "logogif.gif")
            self.imageLogogif.setGifImage(gif, loopCount: -1) // Will loop forever

        } catch {
            print(error)
        }
        view.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 228/255, alpha: 1)
     
    }
}
