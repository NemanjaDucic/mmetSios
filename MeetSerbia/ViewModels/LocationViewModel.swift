//
//  LocationViewModel.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 8.8.23..
//

import Foundation
import SwiftSoup
import FirebaseDatabase
import FirebaseStorage
class LocationViewModel {
    var nameLabel: String = ""
    var attributedDescription: NSAttributedString = NSAttributedString()
    var videoURL: URL?
    var imageUrls: [String] = []
    private let storageRef = Storage.storage().reference()
    private let refrence = Database.database().reference()

    typealias CompletionHandler = () -> Void
    var onViewModelUpdated: CompletionHandler?

    
     func fetchImageUrls(id: String) {
        self.storageRef.child("images/locations/\(id)").listAll { [weak self] res, err in
            if err == nil {
                var urls: [String] = []
                for item in res!.items {
                    item.downloadURL { [weak self] url, error in
                        if let url = url {
                            let urlString = url.absoluteString 
                            urls.append(urlString)
                            if urls.count == res?.items.count {
                                self?.imageUrls.append(contentsOf: urls)
                
                                self?.onViewModelUpdated?()
                            }
                        }
                    }
                }
            }
        }
    }



}
