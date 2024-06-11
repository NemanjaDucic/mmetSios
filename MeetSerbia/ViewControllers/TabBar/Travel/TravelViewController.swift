//
//  TravelViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import UIKit
import MapboxMaps
import MapboxCoreMaps
import CoreLocation
import Firebase
import MapboxCommon
import MapboxNavigationCore
import MapboxNavigationUIKit
import MapboxDirections
import iProgressHUD

class TravelViewController: UIViewController, CLLocationManagerDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource, NavigationFilterTapped {
    func buttonTapped(in cell: CategoriesInNavigationTableViewCell) {
        guard let indexPath = filterViewTableView.indexPath(for: cell) else {
              return
          }
        filterSelected[indexPath.row].toggle()
        stringFilters.toggle(element: filterCellData[indexPath.row].categoryLat.lowercased())
        filterViewTableView.reloadData()
    }
    
    
    private let storageRef = Storage.storage().reference()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscape,.landscapeLeft,.landscapeRight]
    }
    var landscapeConstraints: [NSLayoutConstraint] = []
    private var isAnotationSelected = false

    //LOCAL HOLDERS
    private var coordinatePointsArray = [CoordinateModel]() // SLUZI U SLUCAJU DA SACUVAMO RUTU
    private var coordinatesForPointsFromAdd = [CoordinateModel]()
    var waypointsArray : [Waypoint] = []// WAYPOINTI ZA NAVIGACIJU
    var wayPointsAditionalyAded : [Waypoint] = [] // WAYPOINTI IZ ADD BUTTONA
    var pointAnnotationManager : PointAnnotationManager?
    var selectedAnnotation: PointAnnotation? //SELEKTOVANA ANOTACIJA
    private var selectedLocationStart:LocationModel?
    private var selectedLocationEnd:LocationModel?
    var currentLatitude: CLLocationDegrees?
    var currentLongitude: CLLocationDegrees?
    private var filteredData = [String]()
    var locationManager = CLLocationManager()
    var didSelectSearchForStartingPoint = false
    private var isNavigationFinished = false
    private var stringFilters = [String]()
    
    // BOOL ARRAY ZA CEKIRANE FILTERE
    private var filterSelected = [false,false,false,false,false,false,false,false,false,false,false,false]
    private var filterCellData = CategoryData().items
    private var selectedCategoryIndex: Int?
    var isShowingSubcategories = false

    
    // OUTLETS
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mhHolderView: UIView!
    @IBOutlet weak var holderImage: UIImageView!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var holderLabel: UILabel!
    @IBOutlet weak var holderView: UIStackView!
    @IBOutlet weak var saveRoutesButton: UIButton!
    @IBOutlet weak var showLocalitiesButton: UIButton!
    @IBOutlet weak var startNavButton: UIButton!
    @IBOutlet weak var searchTableBiew: UITableView!
    @IBOutlet weak var searchEnd: UISearchBar!
    @IBOutlet weak var seachStart: UISearchBar!
    internal var mapView: MapView!
    @IBOutlet weak var stackView: UIStackView!

    //FILTER VIEW
    @IBOutlet weak var filtersViewHolder: UIView!
    @IBOutlet weak var filterViewLabel: UILabel!
    @IBOutlet weak var filterViewButton: UIButton!
    @IBOutlet weak var filterViewBar: UISlider!
    @IBOutlet weak var filterViewTableView: UITableView!
    @IBOutlet weak var filterViewBottomLabel: UILabel!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
       
        self.mhHolderView.addSubview(mapView)
        self.mhHolderView.bringSubviewToFront(searchEnd)
        self.mhHolderView.bringSubviewToFront(seachStart)
        self.mhHolderView.bringSubviewToFront(searchTableBiew)
        self.mhHolderView.bringSubviewToFront(startNavButton)
        self.mhHolderView.bringSubviewToFront(showLocalitiesButton)
        self.mhHolderView.bringSubviewToFront(saveRoutesButton)
        self.mhHolderView.bringSubviewToFront(stackView)
        self.mhHolderView.bringSubviewToFront(holderView)
        self.mhHolderView.bringSubviewToFront(holderLabel)
        self.mhHolderView.bringSubviewToFront(filtersViewHolder)
    
    }
    @objc func orientationChanged() {
        let isPortrait = UIDevice.current.orientation.isPortrait
        
        adjustMapViewFrame(!isPortrait)
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
     }
    private func adjustMapViewFrame(_ isPortrait: Bool) {
        seachStart.isHidden = isPortrait ? true : false
        searchEnd.isHidden = isPortrait ? true : false
        navigationController?.navigationBar.isHidden = isPortrait ? true : false
        tabBarController?.tabBar.isHidden = isPortrait ? true: false
        mhHolderView.translatesAutoresizingMaskIntoConstraints = isPortrait ? false: false

        if !isPortrait {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            mhHolderView.frame = view.bounds
            
         } else {
           
             NSLayoutConstraint.activate(landscapeConstraints)
         }
        
      }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTableBiew {
            let cell = UITableViewCell()
            cell.textLabel?.text = filteredData[indexPath.row]
            return cell
        } else {
            let cell = filterViewTableView.dequeueReusableCell(withIdentifier: "filterTableCell", for: indexPath) as! CategoriesInNavigationTableViewCell
            
            if UserDefaultsManager.language == "lat" {
                cell.categoryNameLabel.text = filterCellData[indexPath.row].categoryLat
            } else if UserDefaultsManager.language == "eng" {
                cell.categoryNameLabel.text = filterCellData[indexPath.row].categoryEng
                
            } else {
                cell.categoryNameLabel.text = filterCellData[indexPath.row].category

            }
            let imageName = filterSelected[indexPath.row] ? "checkmark.square" : "squareshape"
            cell.checkButton.setImage(UIImage(systemName: imageName), for: .normal)
            cell.arrowButton.isHidden = filterCellData[indexPath.row].subcategory.count == 1 || filterCellData[indexPath.row].subcategory.count == 0
          

            cell.delegate = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == searchTableBiew {
           return filteredData.count
        } else {
            return filterCellData.count
        }
    }
    private func setupLandscapeConstraints() {
        // Define your landscape constraints here
        landscapeConstraints = [
            mhHolderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mhHolderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mhHolderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mhHolderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ]
    }
    private  func initSetup(){
        holderView.isHidden = true
        stackView.isHidden = true
        saveRoutesButton.isHidden = true
        addbtn.layer.cornerRadius = 15
        searchEnd.delegate = self
        seachStart.delegate = self
        searchTableBiew.dataSource = self
        searchTableBiew.delegate = self
        setupLandscapeConstraints()
        searchTableBiew.isHidden = true
        filterViewTableView.delegate = self
        filterViewTableView.dataSource = self
        filterViewLabel.text = Utils().getChooseLocalitiesNavigationText()
        filterViewBottomLabel.text = Utils().getRadiusText()
        filterViewTableView.register(UINib(nibName: "CategoriesInNavigationTableViewCell", bundle: nil), forCellReuseIdentifier: "filterTableCell")
        holderView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        holderView.isLayoutMarginsRelativeArrangement = true
        // Create Button
               let button = UIButton(type: .custom)
               button.setTitle("", for: .normal)
               button.setTitleColor(.white, for: .normal)
               button.backgroundColor = .clear
               button.translatesAutoresizingMaskIntoConstraints = false
            if let image = UIImage(named: "x")?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
            button.tintColor = UIColor.systemGray5  // Set your desired color here
             }
               button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
                holderView.addSubview(button)
                NSLayoutConstraint.activate([
                  button.topAnchor.constraint(equalTo: holderView.topAnchor, constant: 16),
                  button.trailingAnchor.constraint(equalTo: holderView.trailingAnchor, constant: -16),
                  button.widthAnchor.constraint(equalToConstant: 40),
                  button.heightAnchor.constraint(equalToConstant: 40)
              ])
        filterViewButton.setTitle(Utils().getSaveText(), for: .normal)
        buttonBack.isHidden = true
        // Delegates
        locationManager.delegate = self
        self.tabBarController?.selectedIndex = 2
        mapinit()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        view.updateCaption(text: Utils().loadingText())
        mapView.addGestureRecognizer(tapGesture)
        filterViewBar.maximumValue = 150
        filterViewBar.minimumValue = 0
        filterViewBar.value = 50
        kmLabel.text = "50" + Utils().getKMText()
        filterViewBar.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

        filtersViewHolder.isHidden = true

    }
    @objc func sliderValueChanged(_ sender: UISlider) {
          // Update the label text based on the slider value
        kmLabel.text = String(format: "%.0f", sender.value) + Utils().getKMText()
      }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        searchTableBiew.isHidden = true
        view.endEditing(true)
        filtersViewHolder.isHidden = true
    }
    @objc func closeButtonTapped() {
        holderView.isHidden = true
       }
    private func mapinit(){
        let centerCoordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
             let options = MapInitOptions(cameraOptions: CameraOptions(center: centerCoordinate,
                                                                       zoom: 9.0))
        mapView = MapView(frame: mhHolderView.bounds   , mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isUserInteractionEnabled = true
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager!.delegate = self
        let width = Constants.serbiaNorthEast.longitude - Constants.serbiaSouthWest.longitude
        let height = Constants.serbiaNorthEast.latitude - Constants.serbiaSouthWest.latitude
        let expansionWidth = width * 0.15
        let expansionHeight = height * 0.15
        let expandedSouthWest = CLLocationCoordinate2D(latitude: Constants.serbiaSouthWest.latitude - expansionHeight, longitude: Constants.serbiaSouthWest.longitude - expansionWidth)
        let expandedNorthEast = CLLocationCoordinate2D(latitude: Constants.serbiaNorthEast.latitude + expansionHeight, longitude: Constants.serbiaNorthEast.longitude + expansionWidth)
        let bounds = CoordinateBounds(southwest: expandedSouthWest,
        northeast: expandedNorthEast)
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(currentDestinationTextFieldTapped)))
        try? mapView.mapboxMap.setCameraBounds(with: CameraBoundsOptions(bounds: bounds))

    }

    @objc func currentDestinationTextFieldTapped(){
        searchTableBiew.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedLocationStart = nil
        searchTableBiew.isHidden = true
        selectedLocationEnd = nil
        searchEnd.text = ""
        seachStart.text = ""
        saveRoutesButton.isHidden = true
        stackView.isHidden = true
        holderView.isHidden = true
        
        if Constants().userDefLangugaeKey == "eng"{
            searchEnd.placeholder = "Enter Destination"
            seachStart.placeholder = "Enter starting point"
        } else if Constants().userDefLangugaeKey == "lat" {
            searchEnd.placeholder = "Unesite željenu destinaciju"
            seachStart.placeholder = "Unesite početnu lokaciju"

        } else {
            searchEnd.placeholder = "Унесите жељену дестинацију"
            seachStart.placeholder = "Унесите почетну локацију"
        }
        addbtn.setTitle(Constants().getAddToRoute(), for: .normal)
        showLocalitiesButton.setTitle(Constants().getShowLocalities(), for: .normal)
        saveRoutesButton.setTitle(Constants().getSaveRoute(), for: .normal)
        startNavButton.setTitle(Constants().getMyPath(), for: .normal)
        if isNavigationFinished {
            isNavigationFinished = false
            self.tabBarController?.selectedIndex = 1
        }
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            startLocationUpdates()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            startLocationUpdates()
        default:
            break
        }
    }
    
    func startLocationUpdates() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTableBiew {
            guard indexPath.row < filteredData.count else {
                return
            }
            let selectedLocation = filteredData[indexPath.row]
            if didSelectSearchForStartingPoint{
                seachStart.searchTextField.text = selectedLocation
                seachStart.endEditing(true)
                if Constants().userDefLangugaeKey == "eng"{
                    selectedLocationStart = LocalManager.shared.allLocations.first{$0.nameEng.lowercased() == selectedLocation.lowercased()}
                } else if Constants().userDefLangugaeKey == "lat" {
                    selectedLocationStart = LocalManager.shared.allLocations.first{$0.nameLat.lowercased() == selectedLocation.lowercased()}
                } else {
                    selectedLocationStart = LocalManager.shared.allLocations.first{$0.nameCir.lowercased() == selectedLocation.lowercased()}
                }
                selectedLocationStart = LocalManager.shared.allLocations.first{$0.nameLat.lowercased() == selectedLocation.lowercased()}
                
                searchTableBiew.reloadData()
            } else {
                searchEnd.endEditing(true)
                searchEnd.searchTextField.text = selectedLocation
                if Constants().userDefLangugaeKey == "eng"{
                    selectedLocationEnd = LocalManager.shared.allLocations.first{$0.nameEng.lowercased() == selectedLocation.lowercased()}
                } else if Constants().userDefLangugaeKey == "lat" {
                    selectedLocationEnd = LocalManager.shared.allLocations.first{$0.nameLat.lowercased() == selectedLocation.lowercased()}
                } else {
                    selectedLocationEnd = LocalManager.shared.allLocations.first{$0.nameCir.lowercased() == selectedLocation.lowercased()}
                }
                
                searchTableBiew.reloadData()
                
            }
            searchTableBiew.isHidden = true
            
            if selectedLocationEnd != nil  {
                searchTableBiew.isHidden = true
                saveRoutesButton.isHidden = false
                stackView.isHidden = false
            }
        } else {
            if buttonBack.isHidden {
                let selectedCategory = filterCellData[indexPath.row]
                if selectedCategory.subcategory.count != 1 {
                    isShowingSubcategories = true
                    selectedCategoryIndex = indexPath.row
                    var subcategoryData: [DataModel] = []
                    for i in 0..<selectedCategory.subcategory.count {
                        let subcategory = DataModel(
                            category: selectedCategory.subcategory[i],
                            categoryEng: selectedCategory.subcategoryEng[i],
                            categoryLat: selectedCategory.subcategoryLat[i],
                            subcategory: [],
                            subcategotyLat: [],
                            subcategoryEng: [],
                            expanded: false,
                            categoryImageData: "",
                            imageData: []
                        )
                        subcategoryData.append(subcategory)
                    }
                    buttonBack.isHidden = false
                    filterSelected.removeAll()
                    for i in  subcategoryData {
                        filterSelected.append(false)
                    }
                    filterViewLabel.text = buttonBack.isHidden ? Utils().getChooseLocalitiesNavigationText() : Utils().getSubcategoryPickText()
                    
                    
                    filterCellData = subcategoryData
                    filterViewTableView.reloadData()
                }
            } else {
                print("stojan")
            }
        }

    }
    private func showLocationsWithiBoundsWithFilters(locationModels:[LocationModel]) -> [LocationModel]{
        let filteredLocationModels = locationModels.filter { location in
            stringFilters.contains(location.primaryCategory) ||
            location.subcat.contains { subcategory in
                stringFilters.contains(subcategory)
            }
        }
        return filteredLocationModels
    }
    
    @IBAction func useFiltersButtonClick(_ sender: Any) {
        var myLocation = CLLocationCoordinate2D(latitude: currentLatitude!, longitude: currentLongitude!)
        var destionation = CLLocationCoordinate2D(latitude: selectedLocationEnd!.lat, longitude: selectedLocationEnd!.lon)
        if selectedLocationStart != nil {
            
            var currentLocation = CLLocationCoordinate2D(latitude: selectedLocationStart!.lat, longitude: selectedLocationStart!.lon)
            
            addAnnotations(getProximityAnnotations(start: Point(currentLocation), end: Point(destionation), oneMore: Point(myLocation), radius:Double(filterViewBar.value)).0,getProximityAnnotations(start: Point(currentLocation), end: Point(destionation), oneMore: Point(myLocation), radius:  Double(filterViewBar.value)).1)
        } else {
            var twoLocations = getProximityAnnotationsForTwoLocations(start: Point(myLocation), end: Point(destionation),radius: Double(filterViewBar.value))
            addAnnotations(showLocationsWithiBoundsWithFilters(locationModels: twoLocations.0), twoLocations.1)
        }
        filtersViewHolder.isHidden = true

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.mapView.mapboxMap.setCamera(to: CameraOptions(center: location.coordinate, zoom:14))
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                if let name = placemark.name {
                    print(name)
                    self.seachStart.text =  name + ( " , "  + (placemark.locality ?? "" ))
                    
                } else {
                    print("Location name not found")
                }
            } else {
                print("No placemarks found")
            }
        }
        print(location,"lokacija")
        currentLatitude = location.coordinate.latitude
        currentLongitude = location.coordinate.longitude
        let yourCoordinate = CLLocationCoordinate2D(latitude: self.currentLatitude!, longitude: self.currentLongitude! )
        
        var pointAnnotation = PointAnnotation(coordinate: yourCoordinate)
        pointAnnotation.image = .init(image: UIImage(named: "pin")!, name: "Ви")
        pointAnnotation.iconAnchor = .bottom
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager.delegate = self
        pointAnnotationManager.annotations = [pointAnnotation]
        
        locationManager.stopUpdatingLocation()
    }
    func mapView(_ mapView: MapView, tapOnCalloutFor annotation: Annotation) {
        if annotation is PointAnnotation {
            print("Tapped on marker with title: ")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startLocationUpdates()
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Access Denied", message: "Please grant location access in the Settings app to use this feature.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    @IBAction func filterBackButton(_ sender: Any) {
        if isShowingSubcategories {
                  isShowingSubcategories = false
                    buttonBack.isHidden = true
            filterSelected.removeAll()
                  filterCellData = CategoryData().items
            for i in filterCellData {
                filterSelected.append(false)
            }
                  filterViewTableView.reloadData()
            
              }
        filterViewLabel.text = buttonBack.isHidden ? Utils().getChooseLocalitiesNavigationText() : Utils().getSubcategoryPickText()

    }
    
    @IBAction func saveRouteClick(_ sender: Any) {
        var coordinateStart = CoordinateModel(lat: currentLatitude ?? 0.0, lon: currentLongitude ?? 0.0)
        var coordinateCurrent = CoordinateModel(lat: selectedLocationStart?.lat ?? 00.0,lon: selectedLocationStart?.lon ?? 0.0)
        var coordinateEnd = CoordinateModel(lat: selectedLocationEnd?.lat ?? 0.0,lon: selectedLocationEnd?.lon ?? 0.0)
        saveRoutesButton.isHidden = true
        if selectedLocationStart != nil {
            coordinatePointsArray.append(coordinateStart)
            coordinatePointsArray.append(coordinateCurrent)
            coordinatePointsArray.append(contentsOf: coordinatesForPointsFromAdd)
            coordinatePointsArray.append(coordinateEnd)
        }
        else {
            coordinatePointsArray.append(coordinateStart)
            coordinatePointsArray.append(contentsOf: coordinatesForPointsFromAdd)
            coordinatePointsArray.append(coordinateEnd)
        }
      
      
        FirebaseWizard().addToFavouriteRoutes(customRoute: CustomRoute(name: seachStart.text! + " - " + searchEnd.text!,points: coordinatePointsArray), completion: {
            added in
            if added {
                self.showToast(message: Constants().getSaved(), font: UIFont(name: "Arial", size: 17.0)!)
            } else {
                self.showToast(message: Constants().getSaveFailed(), font: UIFont(name: "Arial", size: 17.0)!)

            }
        })
    }
    
    @IBAction func showLocalityClicked(_ sender: Any) {
//        var myLocation = CLLocationCoordinate2D(latitude: currentLatitude!, longitude: currentLongitude!)
//        var destionation = CLLocationCoordinate2D(latitude: selectedLocationEnd!.lat, longitude: selectedLocationEnd!.lon)
//
//        if selectedLocationStart != nil {
//            
//            var currentLocation = CLLocationCoordinate2D(latitude: selectedLocationStart!.lat, longitude: selectedLocationStart!.lon)
//            
//            addAnnotations(getProximityAnnotations(start: Point(currentLocation), end: Point(destionation), oneMore: Point(myLocation)).0,getProximityAnnotations(start: Point(currentLocation), end: Point(destionation), oneMore: Point(myLocation)).1)
//        } else {
//            var twoLocations = getProximityAnnotationsForTwoLocations(start: Point(myLocation), end: Point(destionation))
//            addAnnotations(twoLocations.0, twoLocations.1)
//          
//        }
        
        filtersViewHolder.isHidden = false
       
    }
    func getProximityAnnotationsForTwoLocations(start: Point, end: Point, radius: Double) -> ([LocationModel], [TollModel]) {
        // Calculate the midpoint between start and end
        let midLatitude = (start.coordinates.latitude + end.coordinates.latitude) / 2
        let midLongitude = (start.coordinates.longitude + end.coordinates.longitude) / 2
        
        // Convert radius from kilometers to degrees
        let radiusInDegreesLatitude = radius / kilometersPerDegreeLatitude
        let radiusInDegreesLongitude = radius / (cos(midLatitude * .pi / 180) * kilometersPerDegreeLatitude)
        
        let west = midLongitude - radiusInDegreesLongitude
        let east = midLongitude + radiusInDegreesLongitude
        let south = midLatitude - radiusInDegreesLatitude
        let north = midLatitude + radiusInDegreesLatitude
        
        var proximityAnnotations: [LocationModel] = []
        var proximityTolls: [TollModel] = []
        
        for annotation in LocalManager.shared.allLocations {
            let annotationCoordinate = CLLocationCoordinate2D(latitude: annotation.lat, longitude: annotation.lon)
            if (annotationCoordinate.longitude > west && annotationCoordinate.longitude < east &&
                annotationCoordinate.latitude > south && annotationCoordinate.latitude < north) {
                proximityAnnotations.append(annotation)
            }
        }
        for toll in LocalManager.shared.allTolls {
            let tollCoordinate = CLLocationCoordinate2D(latitude: toll.lat, longitude: toll.lon)
            if (tollCoordinate.longitude > west && tollCoordinate.longitude < east &&
                tollCoordinate.latitude > south && tollCoordinate.latitude < north) {
                proximityTolls.append(toll)
            }
        }
        
        return (proximityAnnotations, proximityTolls)
    }
    let kilometersPerDegreeLatitude: Double = 111.0
    // Function to get proximity annotations for three locations
    func getProximityAnnotations(start: Point, end: Point, oneMore: Point, radius: Double) -> ([LocationModel], [TollModel]) {
        // Calculate the centroid of the three points
        let midLatitude = (start.coordinates.latitude + end.coordinates.latitude + oneMore.coordinates.latitude) / 3
        let midLongitude = (start.coordinates.longitude + end.coordinates.longitude + oneMore.coordinates.longitude) / 3
        
        // Convert radius from kilometers to degrees
        let radiusInDegreesLatitude = radius / kilometersPerDegreeLatitude
        let radiusInDegreesLongitude = radius / (cos(midLatitude * .pi / 180) * kilometersPerDegreeLatitude)
        
        let west = midLongitude - radiusInDegreesLongitude
        let east = midLongitude + radiusInDegreesLongitude
        let south = midLatitude - radiusInDegreesLatitude
        let north = midLatitude + radiusInDegreesLatitude
        
        var proximityAnnotations: [LocationModel] = []
        var proximityTolls: [TollModel] = []
        
        for annotation in LocalManager.shared.allLocations {
            let annotationCoordinate = CLLocationCoordinate2D(latitude: annotation.lat, longitude: annotation.lon)
            if (annotationCoordinate.longitude > west && annotationCoordinate.longitude < east &&
                annotationCoordinate.latitude > south && annotationCoordinate.latitude < north) {
                proximityAnnotations.append(annotation)
            }
        }
        for toll in LocalManager.shared.allTolls {
            let tollCoordinate = CLLocationCoordinate2D(latitude: toll.lat, longitude: toll.lon)
            if (tollCoordinate.longitude > west && tollCoordinate.longitude < east &&
                tollCoordinate.latitude > south && tollCoordinate.latitude < north) {
                proximityTolls.append(toll)
            }
        }
        
        return (proximityAnnotations, proximityTolls)
    }

    @IBAction func startNavClicked(_ sender: Any) {
        stackView.isHidden = true
        saveRoutesButton.isHidden = true
            startNavigation()
    }
    
    func startNavigation(){
        view.showProgress()
        isNavigationFinished = true

        waypointsArray.append(Waypoint(coordinate:  LocationCoordinate2D(latitude: currentLatitude!, longitude: currentLongitude!)))
        if selectedLocationStart != nil { waypointsArray.append(Waypoint(coordinate: LocationCoordinate2D(latitude: selectedLocationStart!.lat, longitude: selectedLocationStart!.lon)))}
       
        waypointsArray.append(contentsOf: wayPointsAditionalyAded)
        waypointsArray.append(Waypoint(coordinate: LocationCoordinate2D(latitude: selectedLocationEnd!.lat, longitude: selectedLocationEnd!.lon)))
        let options = NavigationRouteOptions(waypoints: waypointsArray)
        let request = NavigationMapSingleton.shared.mapboxNavigation.routingProvider().calculateRoutes(options: options)
        Task {
               switch await request.result {
               case .failure(let error):
                   self.view.dismissProgress()

                   print(error.localizedDescription)
               case .success(let navigationRoutes):
                   let navigationOptions = NavigationOptions(
                    mapboxNavigation: NavigationMapSingleton.shared.mapboxNavigation,
                    voiceController: NavigationMapSingleton.shared.mapboxNavigationProvider.routeVoiceController,
                    eventsManager: NavigationMapSingleton.shared.mapboxNavigationProvider.eventsManager()
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

        
        waypointsArray.removeAll()
        coordinatePointsArray.removeAll()
        coordinatesForPointsFromAdd.removeAll()
        wayPointsAditionalyAded.removeAll()
       
    }

    func addAnnotations(_ locations: [LocationModel],_ tolls:[TollModel]) {
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
            if Constants().userDefLangugaeKey == "eng"{
                
                if item.images.isEmpty{
                    pointAnnotation.userInfo = ["name":item.nameEng]
                } else {
                    pointAnnotation.userInfo = ["name":item.nameEng,
                                                "image":item.images[0]]
                }
                
                
            } else if Constants().userDefLangugaeKey == "lat" {
                if item.images.isEmpty{
                    pointAnnotation.userInfo = ["name":item.nameLat]
                } else {
                    pointAnnotation.userInfo = ["name":item.nameLat,
                                                "image":item.images[0]]
                }
                
            } else {
                if item.images.isEmpty{
                    pointAnnotation.userInfo = ["name":item.nameCir]
                } else {
                    pointAnnotation.userInfo = ["name":item.nameCir,
                                                "image":item.images[0]]
                }
                
            }
            
            annotationsToAdd.append(pointAnnotation)
        }
        for tl in tolls {
            let coordinate = CLLocationCoordinate2D(latitude: tl.lat, longitude: tl.lon)
            var pointAnnotation = PointAnnotation(coordinate: coordinate)
            pointAnnotation.image = .init(image: UIImage(named: "toll")!, name: tl.nameLat)
            if Constants().userDefLangugaeKey == "eng"{
                
                    pointAnnotation.userInfo = ["name":tl.nameEng]
                
            } else if Constants().userDefLangugaeKey == "lat" {
                    pointAnnotation.userInfo = ["name":tl.nameLat]
                                               
            } else {
                    pointAnnotation.userInfo = ["name":tl.nameCir]
            }
            pointAnnotation.iconAnchor = .bottom
            pointAnnotation.iconSize = .maximum(0.5, 0.5)
            annotationsToAdd.append(pointAnnotation)
        }
        self.pointAnnotationManager?.annotations.removeAll()
        
        self.pointAnnotationManager?.annotations.append(contentsOf: annotationsToAdd)
        
    }
    func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        
        guard annotations.count == 1, let anot = annotations.first as? PointAnnotation else {
            return
        }
        guard !isAnotationSelected else {
            return
        }
        isAnotationSelected = true
        
        if anot.image?.image == UIImage(named: "pin"){
            print("stojan")
        } else {
            selectedAnnotation = anot
            updateHolderView(anot: anot)
            
            
        }
    }
    private func updateHolderView(anot:PointAnnotation){
        
        holderImage.image = nil
        holderView.isHidden = false
        holderLabel.text = anot.userInfo?["name"] as? String ?? ""
        
        
        if anot.userInfo?["image"] != nil {
            storageRef.child(anot.userInfo?["image"] as! String).getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error = error {
                    self.isAnotationSelected = false
                    
                    print("Error downloading image: \(error.localizedDescription)")
                } else {
                    if let imageData = data, let image = UIImage(data: imageData) {
                        self.holderImage.image = image
                        
                    } else {
                        
                        print("Error loading image data")
                    }
                    
                }
            }
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isAnotationSelected = false
        }
        
        
    }
    @IBAction func adBtnClick(_ sender: Any) {
      
        wayPointsAditionalyAded.append(Waypoint(coordinate: (selectedAnnotation?.point.coordinates)!))
        coordinatesForPointsFromAdd.append(CoordinateModel(lat: selectedAnnotation?.point.coordinates.latitude ?? 0.0, lon: selectedAnnotation?.point.coordinates.longitude ?? 0.0))
        holderView.isHidden = true
    }
   
}

extension TravelViewController: AnnotationInteractionDelegate {

    
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if Constants().userDefLangugaeKey == "eng" {
            let filteredData = LocalManager.shared.allLocations.filter { item in
                return item.nameCir.lowercased().contains(searchText.lowercased()) ||
                item.nameLat.lowercased().contains(searchText.lowercased()) ||
                item.nameEng.lowercased().contains(searchText.lowercased())
            }
            self.filteredData = filteredData.map { $0.nameEng.uppercased() }
        } else if Constants().userDefLangugaeKey == "lat" {
            let filteredData = LocalManager.shared.allLocations.filter { item in
                
                return item.nameCir.lowercased().contains(searchText.lowercased()) ||
                item.nameLat.lowercased().contains(searchText.lowercased()) ||
                item.nameEng.lowercased().contains(searchText.lowercased())
            }
            self.filteredData = filteredData.map { $0.nameLat.uppercased() }
        } else {
            let filteredData = LocalManager.shared.allLocations.filter { item in
                return item.nameCir.lowercased().contains(searchText.lowercased()) ||
                item.nameLat.lowercased().contains(searchText.lowercased()) ||
                item.nameEng.lowercased().contains(searchText.lowercased())
            }
            self.filteredData = filteredData.map { $0.nameCir.uppercased() }
        }

        searchTableBiew.isHidden = filteredData.isEmpty
        searchTableBiew.reloadData()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar == searchEnd {
            didSelectSearchForStartingPoint = false
            tableViewTopConstraint.constant = CGFloat(60)

        } else {
            didSelectSearchForStartingPoint = true
            tableViewTopConstraint.constant = CGFloat(0)

        }
        
        searchTableBiew.isHidden = false
        
          return true
      }
}
extension TravelViewController:NavigationViewControllerDelegate {
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




