//
//  FavouriteMapViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 22.3.24..
//

import Foundation
import UIKit
import MapboxCommon
import MapboxCoreNavigation
import MapboxMaps
import MapboxCoreMaps

class FavouriteMapViewController:UIViewController, AnnotationInteractionDelegate{
    func annotationManager(_ manager: MapboxMaps.AnnotationManager, didDetectTappedAnnotations annotations: [MapboxMaps.Annotation]) {
        if let anot = annotations.first as? PointAnnotation{
            let DVC  = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "locationDescVC") as? LocationDescriptionViewController
            DVC?.id = anot.image?.name ?? ""
            DVC?.long = anot.point.coordinates.longitude
            DVC?.lat = anot.point.coordinates.latitude
            self.navigationController?.pushViewController(DVC!, animated: true)
        }
    }
    
    
    @IBOutlet weak var mapholderView: UIView!
    var pointAnnotationManager : PointAnnotationManager?
    let serbiaSouthWest = CLLocationCoordinate2D(latitude: 42.245826, longitude: 18.829444)
    let serbiaNorthEast = CLLocationCoordinate2D(latitude: 46.193056, longitude: 23.013334)
    internal var mapView: MapView!
    var reciverdLocations = [LocationModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let myResourceOptions = ResourceOptions(accessToken: "pk.eyJ1IjoibWVldHNlcmJpYSIsImEiOiJjbGY4NHNqb3UxbzJsM3pudGV4eGxrdmw2In0.U7yh9XHMImXSU3CxkLRbDg")
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: mapholderView.bounds   , mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isUserInteractionEnabled = true
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager!.delegate = self
        let width = serbiaNorthEast.longitude - serbiaSouthWest.longitude
        let height = serbiaNorthEast.latitude - serbiaSouthWest.latitude
        mapholderView.addSubview(mapView)
        let bounds = CoordinateBounds(southwest: serbiaSouthWest,
        northeast: serbiaNorthEast)
        try? mapView.mapboxMap.setCameraBounds(with: CameraBoundsOptions(bounds: bounds))
        let camera = mapView.mapboxMap.camera(for: bounds, padding: .zero, bearing:0, pitch: 0)
        mapView.mapboxMap.setCamera(to: camera)
        addAnnotations(reciverdLocations)
    }
    func addAnnotations(_ locations: [LocationModel]) {
        var annotationsToAdd: [PointAnnotation] = []
        for item in locations {
           
            let coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
            var pointAnnotation = PointAnnotation(coordinate: coordinate)
            if item.subcat.contains("mobilna"){
                pointAnnotation.image = .init(image: UIImage(named: "mts_pin")!, name: item.id)
            } else {
                pointAnnotation.image = UIImage(named: Utils().getPinForCategory(category: item.category)).map { .init(image: $0, name: item.id) }
            }
            pointAnnotation.iconAnchor = .bottom
            pointAnnotation.iconSize = .maximum(0.5, 0.5)

            annotationsToAdd.append(pointAnnotation)
        }
        
        self.pointAnnotationManager?.annotations.removeAll()
        self.pointAnnotationManager?.annotations.append(contentsOf: annotationsToAdd)
       
        self.view.dismissProgress()
    }


}
