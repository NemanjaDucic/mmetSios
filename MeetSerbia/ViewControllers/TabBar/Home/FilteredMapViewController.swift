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
import iProgressHUD
import MapboxNavigationCore


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
    private var isAnotationSelected = false
    var landscapeConstraints: [NSLayoutConstraint] = []
    var isDisabledEnabled = false
    let allCategories = CategoryData().items as [DataModel]
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
    private var  selectedFilters = [String]()
    var pointAnnotationManager : PointAnnotationManager?
     var sentFromSearch:Bool?
    var selectedSub = ""
    private var rightBarButton = UIBarButtonItem()

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscape,.landscapeRight,.landscapeLeft]
    }
    private var boolArray = [Bool]()
   
    var locationManager = CLLocationManager()
    internal var mapView: MapView!
    private var allAnotations = [LocationModel]()
    private var filterAnnotations = [LocationModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
      
    }
    
    private func adjustMapViewFrame(_ isPortrait: Bool) {
          mapView.frame = isPortrait ? mhView.bounds : view.bounds
        heightConstraintCV.constant = isPortrait ? 0 : 150
        tabBarController?.tabBar.backgroundColor = isPortrait ? .white : .white
        navigationController?.navigationBar.isHidden = isPortrait ? true : false
        floatinButton.isHidden = isPortrait ? true : false
        if !isPortrait {
            NSLayoutConstraint.deactivate(landscapeConstraints)

            mhView.frame = view.bounds
        } else {
            NSLayoutConstraint.activate(landscapeConstraints)

        }
        
      }
    
    private func setupLandscapeConstraints() {
        // Define your landscape constraints here
        landscapeConstraints = [
            mhView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mhView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mhView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mhView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ]
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
        let text = info.subcategories[indexPath.row]
        if text.contains(" ") {
                 let words = text.split(separator: " ")
                 if words.count > 1 {
                     let midIndex = words.count / 2
                     let firstLine = words[0..<midIndex].joined(separator: " ")
                     let secondLine = words[midIndex..<words.count].joined(separator: " ")
                     cell.titleLabel.text = "\(firstLine)\n\(secondLine)"
                 } else {
                     cell.titleLabel.text = text
                 }
             } else {
                 cell.titleLabel.text = text
             }

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
    func localise () {
      var settingServices:SettingsService{
            SettingsServiceFactory.getInstance(storageType:  .persistent)
        }
        settingServices.set(key: MapboxCommonSettings.language, value: Constants().getMapLanguage())
    }   
    private func multipleCategoriesInfo(categories: [String]) -> (subcategories: [String], images: [String]) {
        var subcategoriesArray = [String]()
        var imagesArray = [String]()
        let allCategories = CategoryData().items as [DataModel]
        
        for category in allCategories {
            if categories.contains(where: { $0.lowercased() == category.categoryLat.lowercased() }) {
                if UserDefaultsManager.language == "lat" {
                    subcategoriesLat.append(category.categoryLat)
                    subcategoriesArray.append(category.categoryLat)
                    imagesArray.append(category.categoryImageData)
                } else if UserDefaultsManager.language == "eng" {
                    subcategoriesArray.append(category.categoryEng)
                    imagesArray.append(category.categoryImageData)
                    subcategoriesLat.append(category.categoryLat)

                } else {
                    subcategoriesArray.append(category.category)
                    imagesArray.append(category.categoryImageData)
                    subcategoriesLat.append(category.categoryLat)
                }
                subcategoriesLat.append(contentsOf: category.subcategoryLat)
                if UserDefaultsManager.language == "lat" {
                    subcategoriesArray.append(contentsOf: category.subcategoryLat)

                } else if UserDefaultsManager.language == "eng" {
                    subcategoriesArray.append(contentsOf: category.subcategoryEng)

                } else {
                    subcategoriesArray.append(contentsOf: category.subcategory)

                }
                imagesArray.append(contentsOf: category.imageData)

            }
        }
        subcategoriesLat = subcategoriesLat.filter { !$0.isEmpty }
        subcategoriesArray = subcategoriesArray.filter { !$0.isEmpty }
        imagesArray = imagesArray.filter { !$0.isEmpty }
   
        return (subcategoriesArray, imagesArray)
    }



    private func initSetup(){
        let uri = StyleURI(rawValue: "mapbox://styles/meetserbia/clx2zlxb3005m01qqdv5j57zo/draft")
//        let uri2 = StyleURI(rawValue: StyleURI.streets)
        let myMapInitOptions = MapInitOptions(styleURI: uri)
        
        setupLandscapeConstraints()
        mapView = MapView(frame: mhView.bounds   , mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isUserInteractionEnabled = true
        mapView.gestures.delegate = self
        mapView.mapboxMap.onEvery(event: .cameraChanged){ [weak self] _ in
        self?.addFilteredAnnotations()
    }
        let width = Constants.serbiaNorthEast.longitude - Constants.serbiaSouthWest.longitude
        let height = Constants.serbiaNorthEast.latitude - Constants.serbiaSouthWest.latitude
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        pointAnnotationManager!.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        view.updateCaption(text: Utils().loadingText())
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
        selectedFilters.append(contentsOf: selectedCategories)
        floatinButton.backgroundColor = nil
        mhView.bringSubviewToFront(floatinButton)
     
        mapView.mapboxMap.onNext(event: .mapLoaded) { [weak self] _ in
                    do {
                        self!.localise()
                    } catch {
                        print("Failed to localize labels: \(error.localizedDescription)")
                    }
                }
       
        
        UserDefaultsManager.getCachedLocations { locations in
                    DispatchQueue.main.async {
                      
                            if self.isDisabledEnabled {
                                self.addAnnotations(locations!.filterLocations(byCategories: self.selectedCategories))
                                self.filtereOutAnnotations()

                            } else {
                                self.addAnnotations(locations!.filterLocations(byCategories: self.selectedCategories))

                            }
                        if self.multipleCategoriesInfo(categories: self.selectedCategories).subcategories.isEmpty {
                            
                        } else {
                            for i in self.multipleCategoriesInfo(categories: self.selectedCategories).images {
                                if Constants().MAIN_CATEGORIES_ENG.contains(i.lowercased()){
                                    self.boolArray.append(true)
                                } else {
                                    self.boolArray.append(false)
                                }
                                self.horizontalCV.reloadData()
                            }
                        }
                        
                    }
                }
        rightBarButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(disableButtonTapped))
        let originalImage = isDisabledEnabled ? UIImage(named: "disabled_enabled")! : UIImage(named: "disabled_disable")!
        let resizedImage = AppUtility().resizeImage(image: originalImage, targetSize: CGSize(width: 24, height: 24))
        rightBarButton.setBackgroundImage(resizedImage, for: .normal, barMetrics: .default)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    @objc func disableButtonTapped() {
            disabledEnabled(enabled: isDisabledEnabled)
       }
    func disabledEnabled(enabled:Bool){
        isDisabledEnabled = !isDisabledEnabled
        var originalImage = UIImage(named: "disabled_enabled")!
        var originalImage2 = UIImage(named: "disabled_disable")!
        if enabled == true {
            let resizedImage = AppUtility().resizeImage(image: originalImage2, targetSize: CGSize(width: 24, height: 24))
            
            rightBarButton.setBackgroundImage(resizedImage, for: .normal, barMetrics: .default)
            
        } else {
            let resizedImage = AppUtility().resizeImage(image: originalImage, targetSize: CGSize(width: 24, height: 24))
            rightBarButton.setBackgroundImage(resizedImage, for: .normal, barMetrics: .default)

        }
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
        self.allAnotations = locations
     
        
        self.view.dismissProgress()
        
    }
    func addFilterAnnotations(_ locations: [LocationModel]) {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pointAnnotationManager?.annotations.append(contentsOf: annotationsToAdd)
        }
     
      
    }
    
    @IBAction func floatingButtonClick(_ sender: Any) {
        filtereOutAnnotations()
         

    }
    func filtereOutAnnotations(){
      
            let allCategories = CategoryData().items as [DataModel]
             var matchingResults = [DataModel]()
            print(selectedFilters)
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
                       
                       selectedFilters.contains { filterCategory in
                           annotation.subcat.contains(filterCategory.lowercased())
                       }
                   }
                 if isDisabledEnabled{
                     addFilterAnnotations(filtered.filter{$0.isAccessible[0] == true})

                 } else {
                     addFilterAnnotations(filtered)

                 }
               } else {
                   print("nema")
                   // THERE ARE MATHCING RESULTS
                      pointAnnotationManager?.annotations.removeAll()
                      filterAnnotations = allAnotations
                      var filtered = [LocationModel]()
                      for matchingCategory in matchingResults {
                          let annotationsForCategory = filterAnnotations.filter { annotation in
                              annotation.category.contains(matchingCategory.categoryLat.lowercased())
                          }
                          filtered.append(contentsOf: annotationsForCategory)
                      }
                   for filterCategory in selectedFilters {
                       if matchingResults.contains(where: { $0.categoryLat.lowercased() == filterCategory.lowercased() }) {
                           continue
                       }
                       let annotationsForSubcategory = filterAnnotations.filter { annotation in
                           annotation.subcat.contains(filterCategory.lowercased())
                       }
                       filtered.append(contentsOf: annotationsForSubcategory)
                   }
                   if isDisabledEnabled {
                       addFilterAnnotations(filtered.filter{ $0.isAccessible[0] == true })
                   } else {
                       addFilterAnnotations(filtered)


                   }

                   
               }
           }

    
}
extension FilteredMapViewController: AnnotationInteractionDelegate {
    public func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        guard annotations.count == 1, let anot = annotations.first as? PointAnnotation else {
                  return
              }
              guard !isAnotationSelected else {
                  return
              }
              isAnotationSelected = true

              let DVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "locationDescVC") as? LocationDescriptionViewController
              DVC?.id = anot.image?.name ?? ""
              DVC?.long = anot.point.coordinates.longitude
              DVC?.lat = anot.point.coordinates.latitude
              if let viewController = DVC {
                  self.navigationController?.pushViewController(viewController, animated: true)
                  
              } else {
                  self.isAnotationSelected = false
              }
          }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        horizontalCV.reloadData()
        isAnotationSelected = false
    }
}
extension FilteredMapViewController:GestureManagerDelegate {
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didBegin gestureType: MapboxMaps.GestureType) {
        if gestureType == .pinch {

            
        } else {
            print("boban")
        }
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEnd gestureType: MapboxMaps.GestureType, willAnimate: Bool) {
//        if gestureType == .pinch {
//            addFilteredAnnotations()
//        } else if gestureType == .pitch {
//            addFilteredAnnotations()
//        } else {
//            addFilteredAnnotations()
//        }
    }
    
    func gestureManager(_ gestureManager: MapboxMaps.GestureManager, didEndAnimatingFor gestureType: MapboxMaps.GestureType) {
        print("boban")
       
    }

    private func addFilteredAnnotations() {
        guard let visibleRegion = try? mapView.mapboxMap.coordinateBounds(for: mapView.frame) else {
                   return
               }
        var anotsToFilter = allAnotations
        print(anotsToFilter.count,"copy of all")
        print(allAnotations.count,"all")
        var zoomedAnotations = anotsToFilter.filter{ location in
            let coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
            return visibleRegion.contains(coordinate)
        }
        print(zoomedAnotations.count,"zoomed")
        if (pointAnnotationManager?.annotations.count ?? 0 > 200) {
            pointAnnotationManager?.annotations.removeAll()
            
        }
        addFilterAnnotations(zoomedAnotations)
       
     }
    

  
}
extension CoordinateBounds {
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        return (southwest.latitude <= coordinate.latitude && coordinate.latitude <= northeast.latitude) &&
               (southwest.longitude <= coordinate.longitude && coordinate.longitude <= northeast.longitude)
    }
}
