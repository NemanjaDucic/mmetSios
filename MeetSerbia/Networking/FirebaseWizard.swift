//
//  FirebaseWizard.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 26.2.24..
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class FirebaseWizard{
    private let refrence = Database.database().reference()
    private let random = UUID().uuidString
    private let storageRef = Storage.storage().reference()
    func addToFavoriteLocations(location:LocationModel){

        refrence.child("users").child(UserDefaultsManager.userID).child("favourites").child("localities").child(location.id).setValue(location.toDictionary())

    }
    func removeFromFavoriteLocations(locationID:String){
        refrence.child("users").child(UserDefaultsManager.userID)  .child("favourites").child("localities").child(locationID).removeValue()
    }
    func getFavorites( completion: @escaping ([LocationModel]?, Error?) -> Void) {
        refrence.child("favorites").child(UserDefaultsManager.userID).observeSingleEvent(of: .value, with: { snapshot  in
            var favorites: [LocationModel] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let jsonData = try? JSONSerialization.data(withJSONObject: snap.value),
                   let location = try? JSONDecoder().decode(LocationModel.self, from: jsonData) {
                    favorites.append(location)
                }
            }
            
            completion(favorites, nil)
        }) { error in
            completion(nil, error)
        }
    }
    func addToFavouriteRoutes(customRoute: CustomRoute ,completion: @escaping(Bool) -> Void) {
     
        let databaseRef = Database.database().reference().child("users").child(UserDefaultsManager.userID).child("favourites").child("routes").child(random)
        
        databaseRef.setValue(customRoute.toDictionary()) { error, _ in
            if let error = error {
                
                print("Error adding route to favourites: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Route added to favourites successfully!")
                completion(true)
            }
           
        }
    }
    func containsFavourite(locationID: String, completion: @escaping (Bool) -> Void) {
        
        
        let favouritesRef = refrence.child("users")
            .child(UserDefaultsManager.userID)
            .child("favourites").child("localities").child(locationID)
        print(favouritesRef)
        favouritesRef.observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }

//    func getAllLocations(completion: @escaping ([LocationModel]?, Error?) -> Void) {
//        let ref = Database.database().reference(withPath: "locations")
//        
//        ref.observeSingleEvent(of: .value) { snapshot in
//            guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value),
//                  let locations = try? JSONDecoder().decode([String: LocationModel].self, from: data) else {
//                completion(nil, NSError(domain: "YourApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve locations"]))
//                return
//            }
//            
//            let locationModels = Array(locations.values)
//            completion(locationModels, nil)
//        }
//    }
    func getAllLocations(completion: @escaping ([LocationModel]?, Error?) -> Void) {
        let ref = Database.database().reference(withPath: "locations")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            do {
                guard let data = try JSONSerialization.data(withJSONObject: snapshot.value as Any) as? Foundation.Data else {
                    throw NSError(domain: "YourApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize snapshot value"])
                }
                
                let locations = try JSONDecoder().decode([String: LocationModel].self, from: data)
                let locationModels = Array(locations.values)
                completion(locationModels, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    func getAllTolls(completion: @escaping ([TollModel]?, Error?) -> Void){
        let ref = Database.database().reference(withPath: "tolls")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value),
                  let locations = try? JSONDecoder().decode([String: TollModel].self, from: data) else {
                completion(nil, NSError(domain: "YourApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve locations"]))
                return
            }
            
            let locationModels = Array(locations.values)
            completion(locationModels, nil)
        }
    }

    func getLocation(byID id: String, completion: @escaping (LocationModel?) -> Void) {
        let ref = Database.database().reference(withPath: "locations").child(id)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
              
                print("Snapshot value is not a valid dictionary")
                completion(nil)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let location = try JSONDecoder().decode(LocationModel.self, from: jsonData)
                completion(location)
            } catch {
                
                print("Error decoding location data: \(error)")
                completion(nil)
            }
        } withCancel: { error in
          
            print("Error fetching location data: \(error.localizedDescription)")
            completion(nil)
        }
    }
    func getFavouriteRoutes(callback: @escaping ([CustomRoute]?) -> Void) {
        let ref = Database.database().reference()
        
        ref.child("users")
            .child(UserDefaultsManager.userID)
            .child("favourites")
            .child("routes")
            .observeSingleEvent(of: .value, with: { snapshot in
                var routes = [CustomRoute]()
                
                for routeSnapshot in snapshot.children {
                    guard let routeData = routeSnapshot as? DataSnapshot else { continue }
                    
                    var points = [CoordinateModel]()
                    if let pointsSnapshot = routeData.childSnapshot(forPath: "points").children.allObjects as? [DataSnapshot] {
                        for pointSnapshot in pointsSnapshot {
                            let lat = pointSnapshot.childSnapshot(forPath: "lat").value as? Double ?? 0.0
                            let long = pointSnapshot.childSnapshot(forPath: "lon").value as? Double ?? 0.0
                            points.append(CoordinateModel(lat: lat, lon: long))
                        }
                    }
                    
                    let name = routeData.childSnapshot(forPath: "name").value as? String ?? ""
                    let customRoute = CustomRoute(name: name, points: points)
                    routes.append(customRoute)
                }
                
                callback(routes)
            }) { error in
                print("Error getting favourite routes: \(error.localizedDescription)")
                callback(nil)
            }
    }
    func getFavouriteLocalities(callback: @escaping ([LocationModel]?) -> Void) {
        let ref = Database.database().reference()
        
        ref.child("users")
            .child(UserDefaultsManager.userID)
            .child("favourites")
            .child("localities")
            .observeSingleEvent(of: .value, with: { snapshot in
                var favourites = [LocationModel]()
                
                for childSnapshot in snapshot.children {
                          guard let localityData = childSnapshot as? DataSnapshot,
                                let localityJSONData = try? JSONSerialization.data(withJSONObject: localityData.value),
                                let locality = try? JSONDecoder().decode(LocationModel.self, from: localityJSONData) else {
                              continue
                          }
                          favourites.append(locality)
                      }
                
                callback(favourites)
            }) { error in
                print("Error getting favourite localities: \(error.localizedDescription)")
                callback(nil)
            }
    }
    func getSaveLocationImage(imageRef: String, completion: @escaping (UIImage?) -> Void) {
        storageRef.child(imageRef).getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
            } else {
                if let imageData = data, let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    print("Error loading image data")
                    completion(nil)
                }
            }
        }
    }
     func uploadImage(uid:String,image:UIImage,type:String){
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let storageRef = Storage.storage().reference().child("images/\(uid)/\(type).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
            } else {
                print("Image uploaded successfully")
                
            }
        }
    }
     func getData(completion: @escaping (String?, UIImage?, UIImage?) -> Void) {
        refrence.child("users").child(UserDefaultsManager.userID).child("data").getData { error, snapshot in
            if let error = error {
                print("Error getting data: \(error.localizedDescription)")
                completion(nil, nil, nil)
                return
            }
            
            guard let dict = snapshot?.value as? [String: Any] else {
                print("Invalid snapshot data")
                completion(nil, nil, nil)
                return
            }
            
            var name: String?
            var profileImage: UIImage?
            var coverImage: UIImage?
            
            // Fetch name
            if let nameFromData = dict["name"] as? String {
                name = nameFromData
            }
            
            // Fetch profile image
            let profileImageRef = Storage.storage().reference().child("images/\(UserDefaultsManager.userID)/profile.jpg")
            profileImageRef.getData(maxSize: 5 * 1024 * 1024) { imageData, error in
                if let error = error {
                    print("Error downloading profile image: \(error.localizedDescription)")
                    completion(name, nil, nil)
                    return
                }
                
                if let imageData = imageData {
                    profileImage = UIImage(data: imageData)
                    // Check if both name and profile image are fetched
                    if let name = name, let profileImage = profileImage, let coverImage = coverImage {
                        completion(name, profileImage, coverImage)
                    }
                }
            }
            
            // Fetch cover image
            let coverImageRef = Storage.storage().reference().child("images/\(UserDefaultsManager.userID)/cover.jpg")
            coverImageRef.getData(maxSize: 5 * 1024 * 1024) { imageData, error in
                if let error = error {
                    print("Error downloading cover image: \(error.localizedDescription)")
                    completion(name, nil, nil)
                    return
                }
                
                if let imageData = imageData {
                    coverImage = UIImage(data: imageData)
                    // Check if both name and cover image are fetched
                    if let name = name, let profileImage = profileImage, let coverImage = coverImage {
                        completion(name, profileImage, coverImage)
                    }
                }
            }
        }
    }
    func getName(completion: @escaping (String?) -> Void) {
        refrence.child("users").child(UserDefaultsManager.userID).child("data").getData { error, snapshot in
            if let error = error {
                print("Error getting data: \(error.localizedDescription)")
                completion(nil) // Call completion with nil indicating failure
                return
            }
            
            guard let dict = snapshot?.value as? [String: Any] else {
                print("Invalid snapshot data")
                completion(nil) // Call completion with nil indicating failure
                return
            }
            
            if let nameFromData = dict["name"] as? String {
                completion(nameFromData) // Call completion with the retrieved name
            } else {
                print("Name not found in data")
                completion(nil) // Call completion with nil indicating failure
            }
        }
    }

     func getYourMemories(completion: @escaping ([MemoryModel]) -> Void) {
         let storageRef = Storage.storage().reference().child("images/memories")
        var localMemoriesArray = [MemoryModel]()
        
        refrence.child("users").child(UserDefaultsManager.userID).child("memories").observeSingleEvent(of: .value,with: { snap in
            for (_, val) in snap.value as? [String: Any] ?? [:] {
                if let memoryData = val as? [String: Any] {
                    let description = memoryData["description"] as? String ?? ""
                    let location = memoryData["location"] as? String ?? ""
                    let id = memoryData["id"] as? String ?? ""
                    storageRef.child(id + ".jpg").getData(maxSize: 5 * 1024 * 1024) { imageData, error in
                        if let imageData = imageData, let image = UIImage(data: imageData) {
                            
                            let memoryModel = MemoryModel(description: description, location: location, id: id, image: image)
                            localMemoriesArray.append(memoryModel)
                        } else {
                            let memoryModel = MemoryModel(description: description, location: location, id: id, image: UIImage())
                            localMemoriesArray.append(memoryModel)
                        }
                        
                        if localMemoriesArray.count == snap.childrenCount {
                            completion(localMemoriesArray)
                        }
                    }
                }
            }
        })
    }
    
    func getVideo(videoURL: String, callback: @escaping (URL?, Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let videoRef = storageRef.child(videoURL)
        
        videoRef.getData(maxSize: Int64.max) { data, error in
            guard let data = data else {
                print("Error downloading video: \(error?.localizedDescription ?? "Unknown error")")
                callback(nil, error)
                return
            }
            
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Documents directory not found")
                callback(nil, nil)
                return
            }
            
            let fileURL = documentsDirectory.appendingPathComponent("video.mp4")
            
            do {
                try data.write(to: fileURL)
                callback(fileURL, nil)
            } catch {
                print("Error saving video to local storage: \(error)")
                callback(nil, error)
            }
        }
    }
    func downloadImages(model: [String], completion: @escaping ([UIImage]?, Error?) -> Void) {
        var downloadedImages = [UIImage?](repeating: nil, count: model.count) // Array to store downloaded images
        let dispatchGroup = DispatchGroup()
        
        for (index, img) in model.enumerated() {
            dispatchGroup.enter()
            self.storageRef.child(img).getData(maxSize: 5 * 1024 * 1024) { imageData, error in
                defer {
                    dispatchGroup.leave()
                }
                
                if let imageData = imageData, let image = UIImage(data: imageData) {
                    downloadedImages[index] = image
                } else {
                    if let error = error {
                        print("Error downloading image: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            
            let filteredImages = downloadedImages.compactMap { $0 }
            completion(filteredImages, nil)
        }
    }
    
}
