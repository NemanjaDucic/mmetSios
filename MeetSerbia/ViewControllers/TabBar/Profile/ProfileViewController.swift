//
//  ProfileViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit
import FirebaseStorage
import Firebase
import iProgressHUD
class ProfileViewController:UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var imageType: String?
    private let wizard = FirebaseWizard()
    private let constants = Constants()
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cirImage: UIImageView!
    @IBOutlet weak var engImage: UIImageView!
    @IBOutlet weak var latImage: UIImageView!
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait  // Force landscape orientation
    }
    override var shouldAutorotate: Bool {
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
        
    }
    private func uiSetup(){
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
  
        view.showProgress()
        view.updateCaption(text: Utils().loadingText())
        switch UserDefaultsManager.language {
        case "eng":
            setLanguageUI(alphaValues: (0.7, 0.7, 1), titles: (constants.memoriesTabArray[2], constants.savedLocationsArray[2], constants.savedRoutesArray[2], constants.membershipArray[2]))
            
        case "cir":
            setLanguageUI(alphaValues: (1, 0.7, 0.7), titles: (constants.memoriesTabArray[0], constants.savedLocationsArray[0], constants.savedRoutesArray[0], constants.membershipArray[0]))
            
        case "lat":
            setLanguageUI(alphaValues: (0.7, 1, 0.7), titles: (constants.memoriesTabArray[1], constants.savedLocationsArray[1], constants.savedRoutesArray[1], constants.membershipArray[1]))
            
        default:
            setLanguageUI(alphaValues: (1, 0.7, 0.7), titles: (constants.memoriesTabArray[0], constants.savedLocationsArray[0], constants.savedRoutesArray[0], constants.membershipArray[0]))
        }
     
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        let cirTap = UITapGestureRecognizer(target: self, action: #selector(cirTapped))
        let latTap = UITapGestureRecognizer(target: self, action: #selector(latTapped))
        let engTap = UITapGestureRecognizer(target: self, action: #selector(engTapped))
        
        profileImageView.addGestureRecognizer(profileTapGesture)
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        let coverTapGesture = UITapGestureRecognizer(target: self, action: #selector(coverImageTapped))
        coverImageView.addGestureRecognizer(coverTapGesture)
        coverImageView.isUserInteractionEnabled = true
        profileImageView.isUserInteractionEnabled = true
        cirImage.addGestureRecognizer(cirTap)
        latImage.addGestureRecognizer(latTap)
        engImage.addGestureRecognizer(engTap)
        cirImage.isUserInteractionEnabled = true
        latImage.isUserInteractionEnabled = true
        engImage.isUserInteractionEnabled = true
        wizard.getName { name in
            if let name = name {
                self.nameLabel.text = name
                self.view.dismissProgress()
            }
        }
        wizard.getData { name, profileImage, coverImage in
            if let name = name {
               print(name)
            }
            
            if let profileImage = profileImage {
                self.profileImageView.image = profileImage
            }
            
            if let coverImage = coverImage {
                self.coverImageView.image = coverImage
            }
//            self.view.dismissProgress()
        }
    
    }
    
    @objc func profileImageTapped() {
        presentImagePicker(for: "profile")
    }
    
    @objc func coverImageTapped() {
        presentImagePicker(for: "cover")
    }
    
    @objc func engTapped() {
        languageTapped(language: "eng", cirAlpha: 0.7, latAlpha: 0.7, engAlpha: 1, titles: [
            constants.memoriesTabArray[2],
               constants.savedLocationsArray[2],
               constants.savedRoutesArray[2],
               constants.membershipArray[2]
           ])

    }
    
    @objc func latTapped() {
        languageTapped(language: "lat", cirAlpha: 0.7, latAlpha: 1, engAlpha: 0.7, titles: [
            constants.memoriesTabArray[1],
            constants.savedLocationsArray[1],
            constants.savedRoutesArray[1],
            constants.membershipArray[1]
        ])

    }
    
    @objc func cirTapped() {
        languageTapped(language: "cir", cirAlpha: 1, latAlpha: 0.7, engAlpha: 0.7, titles: [
            constants.memoriesTabArray[0],
            constants.savedLocationsArray[0],
            constants.savedRoutesArray[0],
            constants.membershipArray[0]
          ])

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    func presentImagePicker(for imageType: String) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: {
            self.imageType = imageType // Store the image type in a variable for later use
        })
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage, let imageType = self.imageType else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        if imageType == "profile" {
            profileImageView.image = image
            wizard.uploadImage(uid: UserDefaultsManager.userID, image: image, type: "profile")
        } else if imageType == "cover" {
            coverImageView.image = image
            wizard.uploadImage(uid: UserDefaultsManager.userID, image: image, type: "cover")
        }
        
        dismiss(animated: true, completion: nil)
    }
    func setLanguageUI(alphaValues: (cir: CGFloat, lat: CGFloat, eng: CGFloat), titles: (String, String, String, String)) {
        cirImage.alpha = alphaValues.cir
        latImage.alpha = alphaValues.lat
        engImage.alpha = alphaValues.eng
        firstButton.setTitle(titles.0, for: .normal)
        secondButton.setTitle(titles.1, for: .normal)
        thirdButton.setTitle(titles.2, for: .normal)
        fourthButton.setTitle(titles.3, for: .normal)
    }
    func languageTapped(language: String, cirAlpha: CGFloat, latAlpha: CGFloat, engAlpha: CGFloat, titles: [String]) {
       UserDefaultsManager.language = language
       firstButton.setTitle(titles[0], for: .normal)
       secondButton.setTitle(titles[1], for: .normal)
       thirdButton.setTitle(titles[2], for: .normal)
       fourthButton.setTitle(titles[3], for: .normal)
       cirImage.alpha = cirAlpha
       latImage.alpha = latAlpha
       engImage.alpha = engAlpha
   }
  
    
    @IBAction func showMemoriesClicked(_ sender: Any) {
        let viewController  = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "memoriesVC") as? MemmoriesViewController
        viewController?.profileImage = profileImageView.image
        viewController?.stojan = "stojan"
        self.navigationController?.pushViewController(viewController!, animated: true)
    }

    @IBAction func locationsClicked(_ sender: Any) {
        let viewController  = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "locVC") as? FavouriteLocationsViewController
      
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    @IBAction func routesClicked(_ sender: Any) {
        let viewController  = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "routeVC") as? FavouriteRoutesViewController
      
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
}
