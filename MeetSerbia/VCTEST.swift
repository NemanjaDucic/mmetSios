////
////  VCTEST.swift
////  MeetSerbia
////
////  Created by Nemanja Ducic on 12.4.24..
////
//
import MapboxDirections
import MapboxMaps
import MapboxNavigationCore
import MapboxNavigationUIKit
import UIKit

class CustomWaypointsViewController:UIViewController, NavigationViewControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.9131752, longitude: -77.0324047), name: "Mapbox")
        let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365), name: "White House")
        
        let options = NavigationRouteOptions(waypoints: [origin, destination])
        let navigationOptions = NavigationOptions(
            mapboxNavigation: NavigationMapSingleton.shared.mapboxNavigation,
            voiceController: NavigationMapSingleton.shared.mapboxNavigationProvider.routeVoiceController,
            eventsManager: NavigationMapSingleton.shared.mapboxNavigationProvider.eventsManager()
        )
        let request = NavigationMapSingleton.shared.mapboxNavigation.routingProvider().calculateRoutes(options: options)
        
        Task {
            switch await request.result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let navigationRoutes):
                let navigationOptions = NavigationOptions(
                    mapboxNavigation: NavigationMapSingleton.shared.mapboxNavigation,
                    voiceController: NavigationMapSingleton.shared.mapboxNavigationProvider.routeVoiceController,
                    eventsManager: NavigationMapSingleton.shared.mapboxNavigationProvider.eventsManager())
                let navigationViewController = NavigationViewController(navigationRoutes: navigationRoutes,
                                                                        navigationOptions: navigationOptions)
                navigationViewController.modalPresentationStyle = .fullScreen
                navigationViewController.delegate = self
                present(navigationViewController, animated: true, completion: nil)
            }
        }
    }
}
