//
//  FavouriteLocationsViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 22.3.24..
//

import Foundation
import UIKit

class FavouriteLocationsViewController:UIViewController,UITableViewDelegate,UITableViewDataSource, DidSelectLocationDelegate{
  
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    private var locations = [LocationModel]()
    private let wizard = FirebaseWizard()
    
    @IBOutlet weak var favouriteLocationsTableView: UITableView!
    private var locationIndex = 0
    @IBOutlet weak var srbButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteLocationsTableView.delegate = self
        favouriteLocationsTableView.dataSource = self
        favouriteLocationsTableView.register(UINib(nibName: "SavedLocationsTableViewCell", bundle: nil), forCellReuseIdentifier: "savedLocations")
        srbButton.layer.cornerRadius = srbButton.layer.bounds.width / 2
        srbButton.clipsToBounds = true
        
        wizard.getFavouriteLocalities { locations in
            if locations != nil {
                self.locations = locations!
                self.favouriteLocationsTableView.reloadData()
            } else {
                self.locations = [LocationModel]()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locations.count
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouriteLocationsTableView.dequeueReusableCell(withIdentifier: "savedLocations", for: indexPath)
        as! SavedLocationsTableViewCell
        let item = locations[indexPath.row]
        cell.delegate = self
        cell.index = indexPath.row
        if item.images.isEmpty {
            cell.locationImage.image = UIImage(named: "srb")
        } else {
            wizard.getSaveLocationImage(imageRef: item.images[0], completion: { locationImage in
                cell.locationImage.image = locationImage
             })
        }
 
        switch UserDefaults.standard.string(forKey: "Language")! {
        case "eng":
            cell.locationNameLabel.text = item.nameEng
            break
        case "cir":
            cell.locationNameLabel.text = item.nameCir
            break
        case "lat":
            cell.locationNameLabel.text = item.nameLat
            break
        default:
            cell.locationNameLabel.text = item.nameCir
        }
        return cell
    }
    @IBAction func srbButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "favouriteMap", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favouriteMap" {
            if let viewController = segue.destination as? FavouriteMapViewController {
                viewController.reciverdLocations = locations
            }
        } else if segue.identifier == "showSingleLocation"{
            if let viewController = segue.destination as? LocationDescriptionViewController {
                viewController.id = locations[locationIndex].id
                viewController.long = locations[locationIndex].lon
                viewController.lat = locations[locationIndex].lat
            }
        }
    }
    func didClickLocation(index: Int) {
        locationIndex = index
        performSegue(withIdentifier: "showSingleLocation", sender: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
     }
}

