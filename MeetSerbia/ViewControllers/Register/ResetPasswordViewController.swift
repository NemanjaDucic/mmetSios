//
//  ResetPasswordViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 29.12.23..
//

import Foundation
import UIKit
import FirebaseAuth

class ResetPasswordViewController:UIViewController{
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var resetButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
    private func initSetup(){
        if Constants().userDefLangugaeKey == "lat"{
            descriptionLabel.text = Constants().descriptionPassResetArray[1]
            resetButton.setTitle(Constants().changePassArray[1], for: .normal)

        } else if Constants().userDefLangugaeKey == "eng"{
            descriptionLabel.text = Constants().descriptionPassResetArray[2]
            resetButton.setTitle(Constants().changePassArray[2], for: .normal)


        } else {
            descriptionLabel.text = Constants().descriptionPassResetArray[0]
            resetButton.setTitle(Constants().changePassArray[0], for: .normal)
            
        }
    }
    @IBAction func resetButtonTapped(_ sender: Any) {
        
        
        
        
        guard let email = emailTF.text, !email.isEmpty else {
            if Constants().userDefLangugaeKey == "lat"{
                showAlert(message: Constants().emptyMSGArray[1])

            } else if Constants().userDefLangugaeKey == "eng"{
                showAlert(message: Constants().emptyMSGArray[2])


            } else {
                showAlert(message: Constants().emptyMSGArray[0])

            }
              
                  return
              }

              Auth.auth().sendPasswordReset(withEmail: email) { error in
                  if let error = error {
          
                      if Constants().userDefLangugaeKey == "lat"{
                          self.showAlert(message: Constants().errMSGArray[1])

                      } else if Constants().userDefLangugaeKey == "eng"{
                          self.showAlert(message: Constants().errMSGArray[2])


                      } else {
                          self.showAlert(message: Constants().errMSGArray[0])

                      }
                  } else {
                      if Constants().userDefLangugaeKey == "lat"{
                          self.showAlert(message: Constants().succMSGArray[1])

                      } else if Constants().userDefLangugaeKey == "eng"{
                          self.showAlert(message: Constants().succMSGArray[2])


                      } else {
                          self.showAlert(message: Constants().succMSGArray[0])

                      }
                  }
              }
        
    }
    func showAlert(message: String) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
