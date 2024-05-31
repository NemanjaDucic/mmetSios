//
//  LaunchScreenViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 10.10.23..
//

import Foundation
import UIKit
import SwiftyGif
import YYCache

class LaunchScreenViewController:UIViewController{
    @IBOutlet weak var animtedImageView: UIImageView!
    
    let cache = NSCache<NSString, AnyObject>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetup()
    }
    private func uiSetup(){
        
        
        animtedImageView.delegate = self
        do {
            let gif = try UIImage(gifName: "logogif.gif")
            self.animtedImageView.setGifImage(gif, loopCount: -1)
                    self.checkAndTrigger()
        } catch {
            print(error)
        }
    }
    
}

extension LaunchScreenViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        
    }
    func checkAndTrigger() {
        UserDefaultsManager.entryCounter += 1
        if UserDefaultsManager.entryCounter % 5 == 0 {
            LocalManager.shared.getAllLocations { models in
                UserDefaultsManager.setCachedLocations(models)
                LocalManager.shared.allLocations = models
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "gifLooped", sender: nil)
                }
                
            }
        } else {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "gifLooped", sender: nil)
            }
            
        }
    }
    
}
