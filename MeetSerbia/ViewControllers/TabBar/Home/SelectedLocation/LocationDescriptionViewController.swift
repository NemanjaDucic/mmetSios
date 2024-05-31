//
//  LocationViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 9.3.23..
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import AVFoundation
import AVKit
import iProgressHUD
import SwiftSoup
import Kingfisher
import CoreLocation
import MapboxDirections
import MapboxNavigationCore
import MapboxNavigationUIKit

class LocationDescriptionViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate, CLLocationManagerDelegate{


    @IBOutlet weak var startNavButton: UIButton!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sampleTextHolder: UITextView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    private var swipeGestureRecognizer = UISwipeGestureRecognizer()
    private var swipeGestureRecognizerRight = UISwipeGestureRecognizer()
    private var locationHasVideo = false
    private var attributedDescription: NSAttributedString = NSAttributedString()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var videoURL: URL?
    var strings = [URL]()
    var locationManager = CLLocationManager()
    var urlString = ""
    var id = ""
    var long = 0.0
    var lat = 0.0
    private let wizard = FirebaseWizard()
    private var currentLocationDisplayed:  LocationModel?
    var locationImages = [UIImage]()


    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
        FirebaseWizard().getLocation(byID: id) { model in
         
            self.currentLocationDisplayed = model
            for i in model!.images {
                print(Storage.storage().reference().child(i))
            }
            switch UserDefaultsManager.language {
            case "eng":
                self.nameLabel.text = model?.nameEng ?? ""
                self.sampleTextHolder.attributedText = model?.descriptionEng.htmlToAttributedStringWithIncreasedFontSize
            case "lat":
                self.nameLabel.text = model?.nameLat ?? ""
                self.sampleTextHolder.attributedText = model?.descriptionLat.htmlToAttributedStringWithIncreasedFontSize

            default:
                self.nameLabel.text = model?.nameCir ?? ""
                self.sampleTextHolder.attributedText = model?.descriptionCir.htmlToAttributedStringWithIncreasedFontSize
            }
            self.wizard.containsFavourite(locationID: self.id) { bool in
                print(bool)
                if bool == true {
                    self.buttonLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                } else {
                    self.buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            }
            if model?.video  != "novideo" {
                self.locationHasVideo = true
                self.wizard.getVideo(videoURL: model?.video ?? "") { url, error in
                    if error != nil {
                        self.view.dismissProgress()
                        
                    } else {
                        self.videoURL = url
                        self.playVideo(in: self.imagesCollectionView)
                        
                        self.view.dismissProgress()
                    }
                    self.wizard.downloadImages(model: model?.images ?? []) { images, error in
                        if error != nil {
                            return
                        } else {
                            self.locationImages = images!
                            self.imagesCollectionView.reloadData()
                            
                        }
                    }
                }
            } else {
                self.wizard.downloadImages(model: model?.images ?? []) { images, error in
                    if error != nil {
                        return
                    } else {
                        self.locationImages = images!
                        self.imagesCollectionView.reloadData()
                        self.view.dismissProgress()
                    }
                }
            }
            
        }
        
    }
    func attributedString(from html: String) -> NSAttributedString? {
        guard let data = html.data(using: .utf8) else {
            return nil
        }

        do {
            let attributedString = try NSAttributedString(data: data,
                                                          options: [.documentType: NSAttributedString.DocumentType.html],
                                                          documentAttributes: nil)
            return attributedString
        } catch {
            print("Error creating attributed string from HTML: \(error)")
            return nil
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    private func initSetup() {
        let nib = UINib(nibName: "ImagesCollectionViewCell", bundle: nil)
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: "imagesCell")
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = imagesCollectionView.frame.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        imagesCollectionView.collectionViewLayout = layout
        sampleTextHolder.delegate = self
        locationManager.delegate = self
        view.showProgress()
        view.updateCaption(text: Utils().loadingText())
        startNavButton.setTitle(Utils().startNavigationText(), for: .normal)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeGestureRecognizer.direction = .left
        swipeGestureRecognizerRight.direction = .left
        swipeGestureRecognizerRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        sampleTextHolder.isSelectable = true
        sampleTextHolder.dataDetectorTypes = .link
        sampleTextHolder.isScrollEnabled = true
        sampleTextHolder.isUserInteractionEnabled = true
        sampleTextHolder.isEditable = false
        var config = UIButton.Configuration.filled()
        config.imagePadding = 30
        config.baseBackgroundColor = .white
        config.baseForegroundColor = . red
        buttonLike.configuration = config
        
    }
    @objc func handleSwipe(_ gestureRecognizer: UISwipeGestureRecognizer){
        playVideo(in: imagesCollectionView)
    }

           
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        locationImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! ImagesCollectionViewCell
            cell.locationImage.image = locationImages[indexPath.row]
    
             return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imagesCollectionView.isScrollEnabled {
            performSegue(withIdentifier: "newident", sender: nil)
        }
          
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          let contentOffset = scrollView.contentOffset
          
          if contentOffset.x < 0 && locationHasVideo {
              playVideo(in: imagesCollectionView)
          }
      }
    private func playVideo(in view: UIView) {
        guard let videoURL = self.videoURL else { return }
        playerLayer?.removeFromSuperlayer()
        self.player = AVPlayer(url: videoURL)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.frame = view.bounds
        self.playerLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(self.playerLayer!)
        self.imagesCollectionView.isScrollEnabled = false
       
        imagesCollectionView.addGestureRecognizer(swipeGestureRecognizer)
        self.player?.play()

    }
    @objc func handleSwipeLeft(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.state == .ended {
          
              player?.pause()
              playerLayer?.isHidden = true
              self.imagesCollectionView.isScrollEnabled = true
              imagesCollectionView.removeGestureRecognizer(swipeGestureRecognizer)
              imagesCollectionView.reloadData()
            if locationImages.count == 1 {
                imagesCollectionView.addGestureRecognizer(swipeGestureRecognizerRight)
                imagesCollectionView.isScrollEnabled = false
            }
          }
      }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newident" {
            if let viewController = segue.destination as? PreviewImageViewController {
                if let selectedIndexPath = imagesCollectionView.indexPathsForSelectedItems?.first {
                    let cell = imagesCollectionView.cellForItem(at: selectedIndexPath) as? ImagesCollectionViewCell
                    if let image = cell?.locationImage.image {
                        viewController.setImage = image
                            viewController.num = selectedIndexPath.row
                            viewController.araayOfImages = locationImages
                    }
                   
                }
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.pause()
       
    }
    
    @IBAction func startNavButtonClick(_ sender: Any) {
     
        if let currentLocation = locationManager.location {
            CLGeocoder().reverseGeocodeLocation(currentLocation) { placemarks, error in
                if let error = error {
                    print("Error getting location: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first {
                    let origin = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                    let endpoint = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
                    let options = NavigationRouteOptions(coordinates: [origin, endpoint])
                 
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

                }
            }
        } else {
            print("Location is nil")
        }


    }
    @IBAction func buttonLikeClick(_ sender: Any) {
        if buttonLike.currentImage == UIImage(systemName: "heart.fill") {
            buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
            wizard.removeFromFavoriteLocations(locationID: id)
        } else {
            buttonLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
            wizard.addToFavoriteLocations(location: currentLocationDisplayed!)
        }
    }

    
}


