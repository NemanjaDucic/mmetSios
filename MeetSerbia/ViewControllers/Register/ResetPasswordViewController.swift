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
    var originalResetButtonY: CGFloat?

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
        // Register notifications
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboard() {
         view.endEditing(true)
     }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.height
            DispatchQueue.main.async {
                // Save the original position if it's not already saved
                if self.originalResetButtonY == nil {
                    self.originalResetButtonY = self.resetButton.frame.origin.y
                }
                
                // Move the button up by the keyboard height
                self.resetButton.frame.origin.y = (self.originalResetButtonY ?? 0) - keyboardHeight
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            if let originalY = self.originalResetButtonY {
                self.resetButton.frame.origin.y = originalY
            }
        }
    }
    deinit{
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
