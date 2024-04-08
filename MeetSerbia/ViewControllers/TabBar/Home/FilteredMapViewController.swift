//
//  HomeNavigationViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 10.4.23..
//

import UIKit
import MapboxMaps
import MapboxCoreMaps
import CoreLocation
import Firebase
import MapboxCommon
import MapboxCoreNavigation
import iProgressHUD


class FilteredMapViewController:UIViewController,CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, SubcategorySelectedDelegate{
    func buttonTapped(in cell: HorizontalCollectionViewCell) {
        guard let indexPath = horizontalCV.indexPath(for: cell) else {
              return
          }
         
        let subcategory = subcategoriesLat[indexPath.row].lowercased()
         selectedFilters.toggle(element: subcategory)
         boolArray[indexPath.row].toggle()
        horizontalCV.reloadData()
       

    }
    
    let allCategories = Data().items as [DataModel]
    private let firebaseWizard = FirebaseWizard()
    @IBOutlet weak var heightConstraintCV: NSLayoutConstraint!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var horizontalCV: UICollectionView!
    @IBOutlet weak var mhView: UIView!
    private let identifier = "horizontalCell"
    @IBOutlet weak var floatinButton: UIButton!
    var selectedCategories = [String]()
    private var images = [String]()
    private var subcategoriesLat = [String]()
    private var selectedFilters = [String]()
    var pointAnnotationManager : PointAnnotationManager?
     var sentFromSearch:Bool?
    var selectedSub = ""
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    private var boolArray = [Bool]()
   
    var locationManager = CLLocationManager()
    internal var mapView: MapView!
    private var allAnotations = [LocationModel]()
    private var filterAnnotations = [LocationModel]()
    lazy var settingsService: SettingsServiceInterface = {
         return SettingsServiceFactory.getInstance(storageType: SettingsServiceStorageType.persistent)
     }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
      
    }
    
    private func adjustMapViewFrame(_ isPortrait: Bool) {
          mapView.frame = isPortrait ? mhView.bounds : view.bounds
        heightConstraintCV.constant = isPortrait ? 0 : 150

      }
    @objc func orientationChanged() {
        let isPortrait = UIDevice.current.orientation.isPortrait
        
        adjustMapViewFrame(!isPortrait)
    }
    deinit {
         NotificationCenter.default.removeObserver(self)
     }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return multipleCategoriesInfo(categories: selectedCategories).subcategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = horizontalCV.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! HorizontalCollectionViewCell
          cell.delegate = self
        let info = multipleCategoriesInfo(categories: selectedCategories)
        cell.titleLabel.text = info.subcategories[indexPath.row]
       
        cell.mainImage.image = UIImage(named:info.images[indexPath.row])

        if boolArray.isEmpty{
            
        } else {
            let imageName = boolArray[indexPath.row] ? "button_checked" : "button_unchecked"
          cell.checkButton.setImage(UIImage(named: imageName), for: .normal)
        }
           

          return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
         if selectedCategories.count == 1 && ((allCategories.first { $0.categoryLat.lowercased() == selectedCategories[0] }?.subcategory.isEmpty) != nil) {
             return CGSize(width: collectionView.bounds.width, height: 130.0)
             
         } else {
             return CGSize(width: 300.0, height: 130.0)
         }

     }

    private func multipleCategoriesInfo(categories: [String]) -> (subcategories: [String], images: [String]) {
        var subcategoriesArray = [String]()
        var imagesArray = [String]()
        let allCategories = Data().items as [DataModel]
        
        for category in allCategories {
            if categories.contains(where: { $0.lowercased() == category.categoryLat.lowercased() }) {
                if Constants().userDefLangugaeKey == "lat" {
                    subcategoriesLat.append(category.categoryLat)
                    subcategoriesArray.append(category.categoryLat)
                    imagesArray.append(category.categoryImageData)
                } else if Constants().userDefLangugaeKey == "eng" {
                    subcategoriesArray.append(category.categoryEng)
                    imagesArray.append(category.categoryImageData)
                    subcategoriesLat.append(category.categoryLat)

                } else {
                    subcategoriesArray.append(category.category)
                    imagesArray.append(category.categoryImageData)
                    subcategoriesLat.append(category.categoryLat)
                }
                subcategoriesLat.append(contentsOf: category.subcategoryLat)
                subcategoriesArray.append(contentsOf: category.subcategory)
                imagesArray.append(contentsOf: category.imageData)

            }
        }
        subcategoriesLat = subcategoriesLat.filter { !$0.isEmpty }
        subcategoriesArray = subcategoriesArray.filter { !$0.isEmpty }
        imagesArray = imagesArray.filter { !$0.isEmpty }
   
        return (subcategoriesArray, imagesArray)
    }



    private func initSetup(){
        let myResourceOptions = ResourceOptions(accessToken: Constants.token)
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: mhView.bounds   , mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isUserInteractionEnabled = true
        let width = Constants.serbiaNorthEast.longitude - Constants.serbiaSouthWest.longitude
        let height = Constants.serbiaNorthEast.latitude - Constants.serbiaSouthWest.latitude
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager!.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        if Constants().userDefLangugaeKey == "eng" {
       
            view.updateCaption(text: "Loading ...")
        } else if Constants().userDefLangugaeKey == "lat"{
        
            view.updateCaption(text: "Učitavanje ...")
        }
        else if Constants().userDefLangugaeKey == "cir"{
            view.updateCaption(text: "Учитавање ...")
         
        } else {
            view.updateCaption(text: "Учитавање ...")

        }
        view.showProgress()
        let expansionWidth = width * 0.15
        let expansionHeight = height * 0.15
        horizontalCV.register(UINib(nibName: "HorizontalCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: identifier)
        horizontalCV.dataSource = self
        horizontalCV.delegate = self
        horizontalCV.allowsMultipleSelection = true
        let layout = UICollectionViewFlowLayout()
                          layout.scrollDirection = .horizontal
                          layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
                          layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        horizontalCV.collectionViewLayout = layout
        let expandedSouthWest = CLLocationCoordinate2D(latitude: Constants.serbiaSouthWest.latitude - expansionHeight, longitude: Constants.serbiaSouthWest.longitude - expansionWidth)
        let expandedNorthEast = CLLocationCoordinate2D(latitude: Constants.serbiaNorthEast.latitude + expansionHeight, longitude: Constants.serbiaNorthEast.longitude + expansionWidth)
        mhView.addSubview(mapView)
        let bounds = CoordinateBounds(southwest: expandedSouthWest,
        northeast: expandedNorthEast)
        try? mapView.mapboxMap.setCameraBounds(with: CameraBoundsOptions(bounds: bounds))
        let camera = mapView.mapboxMap.camera(for: bounds, padding: .zero, bearing:0, pitch: 0)
        mapView.mapboxMap.setCamera(to: camera)
     
        floatinButton.backgroundColor = nil
        mhView.bringSubviewToFront(floatinButton)
        
        if sentFromSearch! {
            
            LocalManager.shared.getAllLocations { locations in
                DispatchQueue.main.async {
                    self.filterAnnotations = locations
                    let filtered = self.filterAnnotations.filter{$0.subcat == self.selectedSub.lowercased()}
                    self.addFilterAnnotations(filtered)
                    self.horizontalCV.reloadData()
                    self.view.dismissProgress()
                }
            }
            
            
        } else {
            if selectedCategories.contains("sve kategorije") {
                LocalManager.shared.getAllLocations { locations in
        DispatchQueue.main.async {
            self.addAnnotations(locations)

            }
                }
            } else{
                LocalManager.shared.getAllLocations { locations in
                    DispatchQueue.main.async {
                        self.addAnnotations(locations.filterLocations(byCategories: self.selectedCategories))
                        if self.multipleCategoriesInfo(categories: self.selectedCategories).subcategories.isEmpty {
                            
                        } else {
                            for i in self.multipleCategoriesInfo(categories: self.selectedCategories).images {
                                if Constants().MAIN_CATEGORIES_ENG.contains(i.lowercased()){
                                    self.boolArray.append(true)
                                } else {
                                    self.boolArray.append(false)
                                }
                               print(i,"ja sam i")
                                self.horizontalCV.reloadData()
                            }
                        }
                        
                    }
                }
            }
        }
        
    }
    func addAnnotations(_ locations: [LocationModel]) {
        var annotationsToAdd: [PointAnnotation] = []
        for item in locations {
           
            let coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
            var pointAnnotation = PointAnnotation(coordinate: coordinate)
            if item.subcat.contains("mobilna"){
                pointAnnotation.image = .init(image: UIImage(named: "mts_pin")!, name: item.id)
            } else if item.nameLat == Constants.VRNJACKA_BANJA {
                pointAnnotation.image = .init(image: UIImage(named: "pin_vrnjacka_banja")!, name: item.id)
            }
            else if item.nameLat == Constants.RUMA {
                pointAnnotation.image = .init(image: UIImage(named: "pin_ruma")!, name: item.id)
            }else {
                pointAnnotation.image = UIImage(named: Utils().getPinForCategory(category: item.category)).map { .init(image: $0, name: item.id) }
            }
            pointAnnotation.iconAnchor = .bottom
            pointAnnotation.iconSize = .maximum(0.5, 0.5)

            annotationsToAdd.append(pointAnnotation)
        }
        
        self.pointAnnotationManager?.annotations.removeAll()
        self.pointAnnotationManager?.annotations.append(contentsOf: annotationsToAdd)
        self.allAnotations = locations
        self.view.dismissProgress()
        
    }
    func addFilterAnnotations(_ locations: [LocationModel]) {
        var annotationsToAdd: [PointAnnotation] = []
        for item in locations {
            let coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
            var pointAnnotation = PointAnnotation(coordinate: coordinate)
            if item.subcat.contains("mobilna"){
                pointAnnotation.image = .init(image: UIImage(named: "mts_pin")!, name: item.id)
            } else if item.nameLat == Constants.VRNJACKA_BANJA {
                pointAnnotation.image = .init(image: UIImage(named: "pin_vrnjacka_banja")!, name: item.id)
            }
            else if item.nameLat == Constants.RUMA {
                pointAnnotation.image = .init(image: UIImage(named: "pin_ruma")!, name: item.id)
            }else {
                pointAnnotation.image = UIImage(named: Utils().getPinForCategory(category: item.category)).map { .init(image: $0, name: item.id) }
            }
            pointAnnotation.iconAnchor = .bottom
            pointAnnotation.iconSize = .maximum(0.5, 0.5)

            annotationsToAdd.append(pointAnnotation)
        }
        self.pointAnnotationManager?.annotations.append(contentsOf: annotationsToAdd)
      
    }
    
    @IBAction func floatingButtonClick(_ sender: Any) {
        filtereOutAnnotations()

    }
    func filtereOutAnnotations(){
                let allCategories = Data().items as [DataModel]
        var matchingResults = [DataModel]()
        for filterCategory in selectedFilters {
            if let matchingCategory = allCategories.first(where: { $0.categoryLat.lowercased() == filterCategory.lowercased() }) {
                matchingResults.append(matchingCategory)
            }
        }
        if matchingResults.isEmpty {
            print("nema")
            // THERE ARENT MATHCING RESULTS
            pointAnnotationManager?.annotations.removeAll()
            filterAnnotations = allAnotations
            let filtered = filterAnnotations.filter { annotation in
                selectedFilters.contains(annotation.subcat.lowercased())
            }
            addFilterAnnotations(filtered)
        } else {
            print("nema")
            // THERE ARE MATHCING RESULTS
               pointAnnotationManager?.annotations.removeAll()
               filterAnnotations = allAnotations
               var filtered = [LocationModel]()
               for matchingCategory in matchingResults {
                   let annotationsForCategory = filterAnnotations.filter { annotation in
                       annotation.category.lowercased() == matchingCategory.categoryLat.lowercased()
                   }
                   filtered.append(contentsOf: annotationsForCategory)
               }
               for filterCategory in selectedFilters {
                   if matchingResults.contains(where: { $0.categoryLat.lowercased() == filterCategory.lowercased() }) {
                       continue
                   }
                   let annotationsForSubcategory = filterAnnotations.filter { annotation in
                       annotation.subcat.lowercased() == filterCategory.lowercased()
                   }
                   filtered.append(contentsOf: annotationsForSubcategory)
               }

            addFilterAnnotations(filtered)
            
        }
    }
    
}
extension FilteredMapViewController: AnnotationInteractionDelegate {
    public func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        if let anot = annotations.first as? PointAnnotation{
            let DVC  = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "locationDescVC") as? LocationDescriptionViewController
            DVC?.id = anot.image?.name ?? ""
            DVC?.long = anot.point.coordinates.longitude
            DVC?.lat = anot.point.coordinates.latitude
            self.navigationController?.pushViewController(DVC!, animated: true)
        }
        
    }
 
}
