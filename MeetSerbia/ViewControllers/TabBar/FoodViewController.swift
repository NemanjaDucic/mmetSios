//
//  FoodViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit
import MapboxMaps
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class FoodViewController: UIViewController, AnnotationInteractionDelegate {
    var navigationMapView: NavigationMapView!
    var routeOptions: NavigationRouteOptions?
    var routeResponse: RouteResponse?
    
    var beginAnnotation: PointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationMapView = NavigationMapView(frame: view.bounds)
        
        view.addSubview(navigationMapView)
        
        navigationMapView.mapView.mapboxMap.onNext(event: .mapLoaded) { [weak self] _ in
            guard let self = self else { return }
            self.navigationMapView.pointAnnotationManager?.delegate = self
        }
        
        navigationMapView.userLocationStyle = .puck2D()
        navigationMapView.navigationCamera.viewportDataSource = NavigationViewportDataSource(navigationMapView.mapView, viewportDataSourceType: .raw)
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        navigationMapView.addGestureRecognizer(longPress)
    }
    
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        let point = sender.location(in: navigationMapView)
        
        let coordinate = navigationMapView.mapView.mapboxMap.coordinate(for: point)
        
        if let origin = navigationMapView.mapView.location.latestLocation?.coordinate {
            calculateRoute(from: origin, to: coordinate)
            print(origin)
            print(coordinate)
        } else {
            print("Failed to get user location, make sure to allow location access for this application.")
        }
    }
    
    func calculateRoute(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let origin = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Започни")
        let destination = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Заврши")
        
        let routeOptions = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        Directions.shared.calculate(routeOptions) { [weak self] (session, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let route = response.routes?.first, let strongSelf = self else {
                    return
                }
                
                strongSelf.routeResponse = response
                strongSelf.routeOptions = routeOptions
                
                strongSelf.drawRoute(route: route)
                
                if var annotation = strongSelf.navigationMapView.pointAnnotationManager?.annotations.first {
                    annotation.textField = "Почни са Навигацијом"
                    annotation.textColor = .init(UIColor.white)
                    annotation.textHaloColor = .init(UIColor.systemBlue)
                    annotation.textHaloWidth = 2
                    annotation.textAnchor = .top
                    annotation.textRadialOffset = 1.0
                    
                    strongSelf.beginAnnotation = annotation
                    strongSelf.navigationMapView.pointAnnotationManager?.annotations = [annotation]
                }
            }
        }
    }
    
    func drawRoute(route: Route) {
        
        navigationMapView.show([route])
        navigationMapView.showRouteDurations(along: [route])
        
        navigationMapView.showWaypoints(on: route)
    }
    
    func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        guard annotations.first?.id == beginAnnotation?.id,
              let routeResponse = routeResponse, let routeOptions = routeOptions else {
            return
        }
        let navigationViewController = NavigationViewController(for: routeResponse, routeIndex: 0, routeOptions: routeOptions)
        navigationViewController.modalPresentationStyle = .fullScreen
        self.present(navigationViewController, animated: true, completion: nil)
    }

}

