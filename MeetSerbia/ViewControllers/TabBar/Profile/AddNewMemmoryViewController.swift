//
//  AddNewMemmoryViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 13.3.23..
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class AddNewMemmoryViewController:UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    private let refrence = Database.database().reference()
    
    let storage = Storage.storage()
    let imagePickerController = UIImagePickerController()
    var selectedImage: UIImage?

    
    @IBOutlet weak var addNewMemmoryButton: UIButton!
    
    @IBOutlet weak var descTitle: UITextField!
    @IBOutlet weak var memoryTitleLabel: UITextField!
    @IBOutlet weak var myJurneyTf: UITextField!
    @IBOutlet weak var enterDescriptionTF: UITextField!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoTitle: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetup()
    }
    
    private func uiSetup(){
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        if Constants().userDefLangugaeKey == "eng" {
            self.title = "ADD NEW MEMORY"
            memoryTitleLabel.text = "Title"
            descTitle.text = "Description"
            enterDescriptionTF.placeholder = "Enter Description..."
            myJurneyTf.placeholder = "My Travel"
            photoTitle.text = "Photography"

        }else if Constants().userDefLangugaeKey == "lat"{
            self.title = "DODAJ NOVU USPOMENU"
            memoryTitleLabel.text = "Naslov"
            descTitle.text = "Opis"
            enterDescriptionTF.placeholder = "Unesi opis..."
            myJurneyTf.placeholder = "Moje Putovanje"
            photoTitle.text = "Fotografija"
            
        }
 
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        memoryTitleLabel.addGestureRecognizer(tapGesture)
        descTitle.addGestureRecognizer(tapGesture)
    view.addGestureRecognizer(tapGesture)
}
@objc func dismissKeyboard() {
     view.endEditing(true)
 }
    
    @IBAction func buttonPickClicked(_ sender: UIButton) {

        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func addNewMemmoryButtonClicked(_ sender: Any) {
        let randomId = NSUUID().uuidString.lowercased()
        
        let memory = ["description":enterDescriptionTF.text!,"location":myJurneyTf.text!,"id":randomId]
        refrence.child("users").child(UserDefaultsManager.userID).child("memories").child(randomId).setValue(memory)
        uploadImage(uid: randomId)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        
            
            self.selectedImage = selectedImage
            self.photoButton.setImage(selectedImage, for: .normal)
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    private func uploadImage(uid:String){
        guard let imageData = selectedImage?.jpegData(compressionQuality: 0.8) else { return }
        let storageRef = Storage.storage().reference().child("images/memories/\(uid).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                print("Image uploaded successfully")
                self.dismiss(animated: true)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }
}

