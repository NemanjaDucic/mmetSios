//
//  RegisterViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit
import Firebase

class RegisterViewController:UIViewController{
    private let refrence = Database.database().reference()
    private let auth = FirebaseAuth.Auth.auth()
    private var flag = false
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var resetPassLabel: UIButton!
    @IBOutlet weak var buttonMainClicked: UIButton!
    @IBOutlet weak var regLogLabel: UIButton!
    var secured = true
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
        self.modalPresentationStyle = .fullScreen

    }
    
    private func uiSetup(){
        regLogLabel.setTitle("Немате налог? Региструј се!", for: .normal)
        buttonMainClicked.setTitle("ПРИЈАВИ СЕ!", for: .normal)
        nameTextField.isHidden = true
        flag = false
        googleButton.isHidden = true
        fbButton.isHidden = true
        nameTextField.setupImageRight(image: "checkmark")
        emailTextField.setupImageRight(image: "checkmark")
        passwordTextField.setupImageRightLong(image: "eye")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secureText)))
        
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        if flag == false {
            tryLogin(email: emailTextField!.text!, password: passwordTextField!.text!)

        } else {
        if checkData(){
            tryRegister(email: emailTextField!.text!, password: passwordTextField!.text!)
        } else {
        }
        }
    }
    @IBAction func regLogClicked(_ sender: Any) {
        if flag == false {
            regLogLabel.setTitle("Већ сте регистровани? Пријави се!", for: .normal)
            buttonMainClicked.setTitle("РЕГИСТРУЈ СЕ!", for: .normal)
            nameTextField.isHidden = false
            resetPassLabel.isHidden = true
            flag = true
        } else {
            regLogLabel.setTitle("Немате налог? Региструј се!", for: .normal)
            buttonMainClicked.setTitle("ПРИЈАВИ СЕ!", for: .normal)
            nameTextField.isHidden = true
            resetPassLabel.isHidden = false

            flag = false
        }
    }
    @objc func secureText(){
        if secured {
            passwordTextField.isSecureTextEntry = false
            passwordTextField.setupImageRightLong(image: "eyeslash")
            passwordTextField.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secureText)))

            } else {
                passwordTextField.setupImageRightLong(image: "eye")
                passwordTextField.isSecureTextEntry = true
                passwordTextField.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secureText)))

            }
        secured = !secured
    }
    
    @IBAction func resetPassTapped(_ sender: Any) {
      performSegue(withIdentifier: "toReset", sender: nil)
    }
    
}
extension UITextField {
 
    func setupImageRight(image:String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(named: image)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        container.addSubview(imageView)
        rightView = container
        rightViewMode = .always
        self.tintColor = .lightGray
    }
    func setupImageRightLong(image:String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 20))
        imageView.image = UIImage(named: image)
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        container.addSubview(imageView)
        rightView = container
        rightViewMode = .always
      
        self.tintColor = .lightGray
    }
    
}
extension RegisterViewController {
    private func checkData() -> Bool {
        if self.passwordTextField.text != nil && self.passwordTextField.text!.count >= 6 {
            return true
        } else {
            
            return false
        }
    }
    private func tryRegister(email:String,password:String){
        Firebase.Auth.auth().createUser(withEmail: email, password: password){[weak self] authResult, error  in
            if error != nil {
                self?.showToast(message: "Погрешни креденцијали", font: UIFont.systemFont(ofSize: 12.0))
                return
            } else {
                let uid = authResult?.user.uid
                var user = ["email":email,"id":uid!,"name":self!.nameTextField.text!]
                self!.refrence.child("users").child(uid!).child("data").setValue(user)
                self!.refrence.child("users").child(uid!).child("memories")
                Firebase.Auth.auth().signIn(withEmail: email, password: password){res,err in
                    if err != nil {
                        return }
                    else {
                        UserDefaultsManager.userID = uid ?? ""
                         
                            UserDefaults.standard.set(true, forKey: "logedIn")
                        UserDefaultsManager.language = "cir"
                            self!.performSegue(withIdentifier: "toMain", sender: nil)
                    
                        }
                }
                
            }
        }
    }
    private func tryLogin(email:String,password:String){
        Firebase.Auth.auth().signIn(withEmail: email, password: password){res,err in
            if err != nil {
                self.showToast(message: "Погрешни креденцијали", font: UIFont.systemFont(ofSize: 12.0))
                return }else {
                    UserDefaultsManager.userID = res?.user.uid ?? ""
                    
                    UserDefaults.standard.set(true, forKey: "logedIn")
                    UserDefaultsManager.language = "cir"
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                    
                }
        }
    }
}

