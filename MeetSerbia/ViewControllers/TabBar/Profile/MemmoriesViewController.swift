//
//  MemmoriesViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit
import Firebase
import SDWebImage
import Kingfisher
import FirebaseStorage
import iProgressHUD

class MemmoriesViewController : UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    let dateArray = ["23. МАЈ 2023 - БАЊСКА СТЕНА"]
    let descArray = ["Прелепо дружење са пријатељима и породицом!"]
    let profileImages = [UIImage(named: "placeholder_profile")]
    let memmoryImages = [UIImage(named: "holder_memmory")]
    
    var stojan = ""
     
    private let wizard = FirebaseWizard()
    @IBOutlet weak var addMemoryButton: UIButton!
    var profileImage:UIImage?
    private var memoriesArray = [MemoryModel(description: "", location: "", id: "",image: UIImage())]
    @IBOutlet weak var memmoriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }
    private func initSetup(){

        memmoriesTableView.register(UINib(nibName: "MemmoryTableViewCell", bundle: nil), forCellReuseIdentifier: "memmoryCell")
        memmoriesTableView.delegate = self
        memmoriesTableView.dataSource = self

        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        addMemoryButton.setTitle(Utils().addNewMemoryText(), for: .normal)
        view.updateCaption(text: Utils().loadingText())
        self.tabBarController?.tabBar.isHidden = true
        view.showProgress()
     


    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = memmoriesTableView.dequeueReusableCell(withIdentifier: "memmoryCell", for: indexPath) as! MemmoryTableViewCell
      
        cell.memmoryImageView.image = memoriesArray[indexPath.row].image
        cell.desriptionLabel.text = memoriesArray[indexPath.row].description
        cell.dateAndLocationLabel.text = memoriesArray[indexPath.row].location
        cell.profileImage.image = profileImage

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wizard.getYourMemories { [weak self] memoriesArray in
        print(memoriesArray)
        guard let self = self else { return }
        self.memoriesArray = memoriesArray
        
        DispatchQueue.main.async {
            self.view.dismissProgress()
            self.memmoriesTableView.reloadData()
        }
    }

    }
    
    @IBAction func addMemoClicked(_ sender: Any) {
        performSegue(withIdentifier: "addMemo", sender: nil)
    }
    
}

