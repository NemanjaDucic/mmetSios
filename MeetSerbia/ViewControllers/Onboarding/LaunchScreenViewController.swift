//
//  LaunchScreenViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 10.10.23..
//

import Foundation
import UIKit
import SwiftyGif

class LaunchScreenViewController:UIViewController{
    @IBOutlet weak var animtedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        

        uiSetup()
    }
    private func uiSetup(){
        animtedImageView.delegate = self
        do {
            let gif = try UIImage(gifName: "logogif.gif")
            self.animtedImageView.setGifImage(gif, loopCount: -1)

        } catch {
            print(error)
        }
        
        LocalManager.shared.getAllLocations { models in
            self.performSegue(withIdentifier: "gifLooped", sender: nil)

        }
     
    }
}
extension LaunchScreenViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        
    }
}
