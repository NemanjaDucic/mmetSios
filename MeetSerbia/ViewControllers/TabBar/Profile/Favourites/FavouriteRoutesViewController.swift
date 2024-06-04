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
import MapboxMaps
import MapboxNavigationUIKit
import iProgressHUD

class FavouriteRoutesViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,SelectedRouteDelegate{
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
 
    private var navigationDidEnd = false
    private var routesArray = [CustomRoute]()
    private let wizard = FirebaseWizard()
    private var coordinatesOfRoute = [CLLocationCoordinate2D]()
    @IBOutlet weak var savedRoutesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        savedRoutesTableView.delegate = self
        savedRoutesTableView.dataSource = self
        savedRoutesTableView.register(UINib(nibName: "SavedRoutesTableViewCell", bundle: nil), forCellReuseIdentifier: "savedRoutesCell")
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        view.updateCaption(text: Utils().loadingText())
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
        view.showProgress()
        navigationDidEnd = true
        let options = NavigationRouteOptions(coordinates: coordinates)
        let request = NavigationMapSingleton.shared.mapboxNavigation.routingProvider().calculateRoutes(options: options)
        Task {
               switch await request.result {
               case .failure(let error):
                   self.view.dismissProgress()
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
                   let image = UIImageView()
                   image.image = UIImage(named: "mts_pin")
                   image.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout

                   navigationViewController.navigationView.addSubview(image)
                   NSLayoutConstraint.activate([
                    image.trailingAnchor.constraint(equalTo: navigationViewController.navigationView.trailingAnchor, constant: -16),
                    image.centerYAnchor.constraint(equalTo:navigationViewController.navigationView.topAnchor,constant: 100 ),
                       image.widthAnchor.constraint(equalToConstant: 30),
                       image.heightAnchor.constraint(equalToConstant: 50)
                   ])
                   self.view.dismissProgress()
                   navigationViewController.delegate = self
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if navigationDidEnd {
            navigationDidEnd = false
            tabBarController?.selectedIndex = 1
        }
    }
}
extension FavouriteRoutesViewController:NavigationViewControllerDelegate {
    func navigationViewControllerDidDismiss(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, byCanceling canceled: Bool) {
        if canceled == true {
        dismiss(animated: true)
        }
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, didUpdate progress: MapboxNavigationCore.RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
        print("didUpdate")
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, didArriveAt waypoint: MapboxDirections.Waypoint) {
        print("onwaypoint")

    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, didAdd finalDestinationAnnotation: MapboxMaps.PointAnnotation, pointAnnotationManager: MapboxMaps.PointAnnotationManager) {
        print("didAdd")
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, didSelect waypoint: MapboxDirections.Waypoint) {
        print("didSelect")
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, willRerouteFrom location: CLLocation?) {
        print("will reroute")
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, didRerouteAlong route: MapboxDirections.Route) {
        print("didRerouteAlong")
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, didUpdateAlternatives updatedAlternatives: [MapboxNavigationCore.AlternativeRoute], removedAlternatives: [MapboxNavigationCore.AlternativeRoute]) {
        print("didUpdateAlternatives")
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, didSwitchToCoincidentOnlineRoute coincideRoute: MapboxDirections.Route) {
        print("didSwitchToCoincidentOnlineRoute")
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, didSelect alternative: MapboxNavigationCore.AlternativeRoute) {
        print("didselect")
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, didFailToRerouteWith error: Error) {
        print("failed to reroute")
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, didRefresh routeProgress: MapboxNavigationCore.RouteProgress) {
        print("refreshed")
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, routeLineLayerWithIdentifier identifier: String, sourceIdentifier: String) -> MapboxMaps.LineLayer? {
        return nil
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, routeCasingLineLayerWithIdentifier identifier: String, sourceIdentifier: String) -> MapboxMaps.LineLayer? {
        return nil
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, routeRestrictedAreasLineLayerWithIdentifier identifier: String, sourceIdentifier: String) -> MapboxMaps.LineLayer? {
        return nil

    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, waypointCircleLayerWithIdentifier identifier: String, sourceIdentifier: String) -> MapboxMaps.CircleLayer? {
        return nil

    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, waypointSymbolLayerWithIdentifier identifier: String, sourceIdentifier: String) -> MapboxMaps.SymbolLayer? {
        return nil

    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, shapeFor waypoints: [MapboxDirections.Waypoint], legIndex: Int) -> Turf.FeatureCollection? {
        return nil

    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, roadNameAt location: CLLocation) -> String? {
        return ""
    }
    
    func navigationViewController(_ navigationViewController: MapboxNavigationUIKit.NavigationViewController, didSubmitArrivalFeedback isPositive: Bool) {
        print("didSubmitFeedback")
    }
}
