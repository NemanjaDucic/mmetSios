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
import MapboxNavigation
import MapboxDirections
import MapboxCoreNavigation

class LocationDescriptionViewController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var startNavButton: UIButton!
    @IBOutlet weak var buttonLike: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sampleTextHolder: UITextView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    private var swipeGestureRecognizer = UISwipeGestureRecognizer()
    private var locationHasVideo = false
    private var attributedDescription: NSAttributedString = NSAttributedString()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var videoURL: URL?
    
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
            //
            self.currentLocationDisplayed = model
            switch UserDefaultsManager.language {
            case "eng":
                self.nameLabel.text = model?.nameEng ?? ""
                self.sampleTextHolder.attributedText = self.formatMixedContent(model?.descriptionEng ?? "")

            case "lat":
                self.nameLabel.text = model?.nameLat ?? ""
               
                self.sampleTextHolder.attributedText = self.formatMixedContent(model?.descriptionLat ?? "")
            default:
                self.nameLabel.text = model?.nameCir ?? ""
                self.sampleTextHolder.attributedText = self.formatMixedContent(model?.descriptionCir ?? "")
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped(_:)))
               sampleTextHolder.addGestureRecognizer(tapGesture)
        view.showProgress()
        view.updateCaption(text: Utils().loadingText())
        startNavButton.setTitle(Utils().startNavigationText(), for: .normal)
 
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeGestureRecognizer.direction = .left
        
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
    @objc func textViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == .ended {
           
            let point = gestureRecognizer.location(in: sampleTextHolder)
            
            if let position = sampleTextHolder.closestPosition(to: point) {
                if let range = sampleTextHolder.tokenizer.rangeEnclosingPosition(position, with: .word, inDirection: .layout(.left)) {
                    sampleTextHolder.selectedTextRange = range
                    if let tappedWord = sampleTextHolder.text(in: range) {
                        print("Tapped Word: \(tappedWord)")
                        if tappedWord == "Link" || tappedWord == "Линк" {
                            var formatedURL = urlString.replacingOccurrences(of: "\"", with: "")
                            if formatedURL.hasPrefix("\\") {
                                formatedURL.removeFirst()
                            }
                            if formatedURL.hasSuffix("\\") {
                                formatedURL.removeLast()
                            }
                            if let fileUrl = URL(string: formatedURL) {
                               
                                 
                                 if UIApplication.shared.canOpenURL(fileUrl) {
                                     UIApplication.shared.open(fileUrl, options: [:], completionHandler: nil)
                                
                                 } else {
                                     print("Error: Cannot open URL \(fileUrl)")
                                 }
                             } else {
                                 print("Error: Invalid URL string")
                             }
                      
                        }
                    }
                    
                }
            }
        }
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
          if let selectedRange = textView.selectedTextRange {
              let selectedText = textView.text(in: selectedRange)
              print("Selected Text: \(selectedText ?? "")")
          }
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
    private func formatMixedContent(_ mixedContent: String) -> NSAttributedString {
        let components = mixedContent.components(separatedBy: "<a")
        let attributedString = NSMutableAttributedString()
        for component in components {
            if component.contains("</a>") {
                do {
                    let doc = try SwiftSoup.parse("<a\(component)")
                    let link = try doc.select("a").first()
                    let linkText = try link?.text() ?? ""
                    let linkURL = try link?.attr("href") ?? ""
                    print(linkURL,"doc")
                    let trimmedLinkString = linkURL.trimmingCharacters(in: .init(charactersIn: "\""))
                    urlString = trimmedLinkString
                    let linkAttributes: [NSAttributedString.Key: Any] = [.link: linkURL]
                    let attributedLink = NSAttributedString(string: linkText, attributes: linkAttributes)
                    attributedString.append(attributedLink)
                } catch {
                    print("Error parsing HTML: \(error)")
                }
            } else {
                let textAttributes: [NSAttributedString.Key: Any] = [:]
                let attributedText = NSAttributedString(string: component, attributes: textAttributes)
                attributedString.append(attributedText)
            }
        }

        return attributedString
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
                    let options = NavigationRouteOptions(coordinates: [origin,endpoint])
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


