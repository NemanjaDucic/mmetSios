////
////  VCTEST.swift
////  MeetSerbia
////
////  Created by Nemanja Ducic on 12.4.24..
////
//
import MapboxDirections
import MapboxMaps
import MapboxNavigationCore
import MapboxNavigationUIKit
import UIKit
import FirebaseDatabase

class CustomWaypointsViewController:UIViewController, NavigationViewControllerDelegate {

    let ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        let oldURLPart = "https://mts.rs/Privatni/Korisnicka-zona/Kontakt/Kako-do-nas"
                let newURLPart = "https://mts.rs/"
        
        
        
        getElementsWithSubcategory(subcategory: "mobilna telefonija") { matchingLocations in
            for (key, location) in matchingLocations {
                print("Key: \(key), Location: \(location)")
            }
            print(matchingLocations.count)
            
        }
//        updateURLsInMatchingElements(subcategory: "mobilna telefonija", oldURLPart: oldURLPart, newURLPart: newURLPart) { error in
//                    if let error = error {
//                        print("Error updating URLs: \(error.localizedDescription)")
//                    } else {
//                        print("URLs successfully updated.")
//                    }
//                }
            
    }
      
    func getElementsWithSubcategory(subcategory: String, completion: @escaping ([String: [String: Any]]) -> Void) {
           // Reference to the 'locations' node
           let locationsRef = ref.child("locations")
           
           // Observe single event to get all locations
           locationsRef.observeSingleEvent(of: .value) { snapshot in
               guard let locations = snapshot.value as? [String: [String: Any]] else {
                   completion([:])
                   return
               }
               
               var matchingLocations = [String: [String: Any]]()
               
               // Iterate through all locations
               for (key, location) in locations {
                   if let subcategories = location["subcat"] as? [String], subcategories.contains(subcategory) {
                       // Add matching location to the results
                       matchingLocations[key] = location
                   }
               }
               
               // Return matching locations
               completion(matchingLocations)
           }
       }
    func updateURLsInMatchingElements(subcategory: String, oldURLPart: String, newURLPart: String, completion: @escaping (Error?) -> Void) {
          getElementsWithSubcategory(subcategory: subcategory) { matchingLocations in
              var updates = [String: Any]()
              
              // Iterate through matching locations
              for (key, location) in matchingLocations {
                  if let descriptionEng = location["descriptionEng"] as? String, descriptionEng.contains(oldURLPart) {
                      let updatedDescriptionEng = descriptionEng.replacingOccurrences(of: oldURLPart, with: newURLPart)
                      updates["\(key)/descriptionEng"] = updatedDescriptionEng
                  }
                  if let descriptionLat = location["descriptionLat"] as? String, descriptionLat.contains(oldURLPart) {
                      let updatedDescriptionLat = descriptionLat.replacingOccurrences(of: oldURLPart, with: newURLPart)
                      updates["\(key)/descriptionLat"] = updatedDescriptionLat
                  }
                  if let descriptionCir = location["descriptionCir"] as? String, descriptionCir.contains(oldURLPart) {
                      let updatedDescriptionCir = descriptionCir.replacingOccurrences(of: oldURLPart, with: newURLPart)
                      updates["\(key)/descriptionCir"] = updatedDescriptionCir
                  }
              }
              
              // Apply updates
              self.ref.child("locations").updateChildValues(updates) { error, _ in
                  completion(error)
              }
          }
      }
}
