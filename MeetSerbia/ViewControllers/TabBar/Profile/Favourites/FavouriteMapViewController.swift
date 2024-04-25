//
//  FavouriteMapViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 22.3.24..
//

import Foundation
import UIKit
import MapboxCommon
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
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscape,.landscapeRight,.landscapeLeft]
    }
    var landscapeConstraints: [NSLayoutConstraint] = []

    
    @IBOutlet weak var mapholderView: UIView!
    var pointAnnotationManager : PointAnnotationManager?
    let serbiaSouthWest = CLLocationCoordinate2D(latitude: 42.245826, longitude: 18.829444)
    let serbiaNorthEast = CLLocationCoordinate2D(latitude: 46.193056, longitude: 23.013334)
    internal var mapView: MapView!
    var reciverdLocations = [LocationModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let myResourceOptions = ResourceOptions(accessToken: Constants.token)
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: mapholderView.bounds   , mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isUserInteractionEnabled = true
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager!.delegate = self
        let width = serbiaNorthEast.longitude - serbiaSouthWest.longitude
        let height = serbiaNorthEast.latitude - serbiaSouthWest.latitude
        mapholderView.addSubview(mapView)
        setupLandscapeConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
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
            if item.subcat.contains("mobilna telefonija"){
                pointAnnotation.image = .init(image: UIImage(named: "mts_pin")!, name: item.id)
            } else if item.nameLat == Constants.VRNJACKA_BANJA {
                pointAnnotation.image = .init(image: UIImage(named: "pin_vrnjacka_banja")!, name: item.id)
            }
            else if item.nameLat == Constants.RUMA {
                pointAnnotation.image = .init(image: UIImage(named: "pin_ruma")!, name: item.id)
            }else {
                pointAnnotation.image = UIImage(named: Utils().getPinForCategory(category: item.primaryCategory)).map { .init(image: $0, name: item.id) }
            }
            pointAnnotation.iconAnchor = .bottom
            pointAnnotation.iconSize = .maximum(0.5, 0.5)

            annotationsToAdd.append(pointAnnotation)
        }
        
        self.pointAnnotationManager?.annotations.removeAll()
        self.pointAnnotationManager?.annotations.append(contentsOf: annotationsToAdd)
       
        self.view.dismissProgress()
    }
    @objc func orientationChanged() {
        let isPortrait = UIDevice.current.orientation.isPortrait
        
        adjustMapViewFrame(!isPortrait)
    }
    private func adjustMapViewFrame(_ isPortrait: Bool) {
        mapholderView.frame = isPortrait ? mapholderView.bounds : view.bounds
        navigationController?.navigationBar.isHidden = isPortrait ? true : false
        
        if !isPortrait {
            NSLayoutConstraint.deactivate(landscapeConstraints)

            mapholderView.frame = view.bounds
        } else {
            NSLayoutConstraint.activate(landscapeConstraints)

        }
        
      }
    private func setupLandscapeConstraints() {
        // Define your landscape constraints here
        landscapeConstraints = [
            mapholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapholderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ]
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
     }

}
