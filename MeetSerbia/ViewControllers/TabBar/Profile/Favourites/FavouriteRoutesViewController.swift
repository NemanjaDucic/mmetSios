//
//  FavouriteRoutesViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 22.3.24..
//

import Foundation
import UIKit
import CoreLocation
import MapboxDirections
import MapboxNavigationCore
import MapboxNavigationUIKit

class FavouriteRoutesViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,SelectedRouteDelegate{
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
 
    
    private var routesArray = [CustomRoute]()
    private let wizard = FirebaseWizard()
    private var coordinatesOfRoute = [CLLocationCoordinate2D]()
    @IBOutlet weak var savedRoutesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        savedRoutesTableView.delegate = self
        savedRoutesTableView.dataSource = self
        savedRoutesTableView.register(UINib(nibName: "SavedRoutesTableViewCell", bundle: nil), forCellReuseIdentifier: "savedRoutesCell")
        wizard.getFavouriteRoutes { routes in
            if routes != nil {
                self.routesArray = routes!
                self.savedRoutesTableView.reloadData()
            } else {
                self.routesArray = [CustomRoute]()
            }

        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  routesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = savedRoutesTableView.dequeueReusableCell(withIdentifier: "savedRoutesCell", for: indexPath) as! SavedRoutesTableViewCell
        let item = routesArray[indexPath.row]
        cell.delegate = self
        cell.configure(index: indexPath.row)
        cell.routeNameLabel.text = item.name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func didSelectRoute(cell: UITableViewCell, route: Int) {
        let item = routesArray[route].points
      
        for i in item{
            coordinatesOfRoute.append(CLLocationCoordinate2D(latitude:i.lat , longitude: i.lon))
        }
        startNavigation(coordinates: coordinatesOfRoute)

    }
    
    func startNavigation(coordinates:[CLLocationCoordinate2D]){
        let options = NavigationRouteOptions(coordinates: coordinates)
        let request = NavigationMapSingleton.shared.mapboxNavigation.routingProvider().calculateRoutes(options: options)
        Task {
               switch await request.result {
               case .failure(let error):
                   print(error.localizedDescription)
               case .success(let navigationRoutes):
                   let navigationOptions = NavigationOptions(
                    mapboxNavigation:NavigationMapSingleton.shared.mapboxNavigation,
                    voiceController: NavigationMapSingleton.shared.mapboxNavigationProvider.routeVoiceController,
                    eventsManager: NavigationMapSingleton.shared.mapboxNavigation.eventsManager()
                    
                   )
                   let navigationViewController = NavigationViewController(
                       navigationRoutes: navigationRoutes,
                       navigationOptions: navigationOptions
                   )
                   
                   navigationViewController.modalPresentationStyle = .fullScreen
                   navigationViewController.routeLineTracksTraversal = true
                   self.present(navigationViewController, animated: true, completion: nil)
               }
           }
        coordinatesOfRoute.removeAll()
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
     }
}
