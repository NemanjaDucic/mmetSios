//
//  InstantNavigationViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 23.2.24..
//

import Foundation
import UIKit
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import CoreLocation

class InstantNavigationViewController:UIViewController, CLLocationManagerDelegate {
//    var navigationMapView: NavigationMapView!
    var locationManager = CLLocationManager()
    var origin :CLLocationCoordinate2D?
    var destinationLat:Double?
    var destinationLon:Double?
    var waypoints = [CLLocationCoordinate2D]()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
//        navigationMapView = NavigationMapView(frame: view.bounds)
//        navigationMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if waypoints.isEmpty {
            getCurrentLocationName()
        } else {
            savedMapNavigation()
        }
        
//        view.addSubview(navigationMapView)

        
    }
    func getCurrentLocationName() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if let currentLocation = locationManager.location {
            CLGeocoder().reverseGeocodeLocation(currentLocation) { placemarks, error in
                if let error = error {
                    print("Error getting location: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first {
                    print(currentLocation.coordinate.latitude)
                    self.origin = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
                    var destination = CLLocationCoordinate2D(latitude: self.destinationLat ?? 0.0, longitude: self.destinationLon ?? 0.0)
                    let options = NavigationRouteOptions(coordinates: [self.origin!, destination])
                    Directions.shared.calculate(options) { [weak self] (_, result) in
                        switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .success(let response):
                            guard let strongSelf = self else {
                                return
                            }
                            let indexedRouteResponse = IndexedRouteResponse(routeResponse: response, routeIndex: 0)
                            let navigationService = MapboxNavigationService(indexedRouteResponse: indexedRouteResponse,
                                                                            customRoutingProvider: NavigationSettings.shared.directions,
                                                                            credentials: NavigationSettings.shared.directions.credentials,
                                                                            simulating: .onPoorGPS)
                            
                            let navigationOptions = NavigationOptions(navigationService: navigationService)
                            let navigationViewController = NavigationViewController(for: indexedRouteResponse,
                                                                                    navigationOptions: navigationOptions)
                            navigationViewController.modalPresentationStyle = .fullScreen
                           
                            navigationViewController.routeLineTracksTraversal = true
                            
                            strongSelf.present(navigationViewController, animated: true, completion: nil)
                        }
                    }
                }
            }
        } else {
            print("Location is nil")
        }
    }
    func savedMapNavigation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if let currentLocation = locationManager.location {
            CLGeocoder().reverseGeocodeLocation(currentLocation) { placemarks, error in
                if let error = error {
                    print("Error getting location: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first {
                  
                    let options = NavigationRouteOptions(coordinates: self.waypoints)
                    Directions.shared.calculate(options) { [weak self] (_, result) in
                        switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .success(let response):
                            guard let strongSelf = self else {
                                return
                            }
                            let indexedRouteResponse = IndexedRouteResponse(routeResponse: response, routeIndex: 0)
                            let navigationService = MapboxNavigationService(indexedRouteResponse: indexedRouteResponse,
                                                                            customRoutingProvider: NavigationSettings.shared.directions,
                                                                            credentials: NavigationSettings.shared.directions.credentials,
                                                                            simulating: .onPoorGPS)
                            
                            let navigationOptions = NavigationOptions(navigationService: navigationService)
                            let navigationViewController = NavigationViewController(for: indexedRouteResponse,
                                                                                    navigationOptions: navigationOptions)
                            navigationViewController.modalPresentationStyle = .fullScreen
                           
                            navigationViewController.routeLineTracksTraversal = true
                            
                            strongSelf.present(navigationViewController, animated: true, completion: nil)
                        }
                    }
                }
            }
        } else {
            print("Location is nil")
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        waypoints.removeAll()
        dismiss(animated: true)
    }
}
