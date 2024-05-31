//
//  LocalMenager.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 29.2.24..
//

import Foundation
class LocalManager {
    static let shared = LocalManager()
     var allLocations: [LocationModel] = []
    var allTolls : [TollModel] = []
    private let firebaseWizard = FirebaseWizard()
    private var isFetchingLocations = false
    
    private init() {
       loadCacnedTolls()
        loadCachedLocations()
    }
    private func loadCachedLocations() {
         UserDefaultsManager.getCachedLocations { locations in
             if let locations = locations {
                 self.allLocations = locations
                 
             }
         }
     }
    private func loadCacnedTolls() {
         UserDefaultsManager.getCachedTolls{ tolls in
             if let tolls = tolls {
                 self.allTolls = tolls
                 
             }
         }
     }
    private func fetchAllLocations() {
         guard !isFetchingLocations else { return }

         isFetchingLocations = true

         firebaseWizard.getAllLocations { [weak self] locations, error in
             guard let self = self else { return }
             defer {
                 self.isFetchingLocations = false
             }
             if let error = error {
                 print("Error fetching locations: \(error)")
             } else if let locations = locations {
                 self.allLocations = locations
                 // Cache fetched locations
                 UserDefaultsManager.setCachedLocations(locations)
             }
         }
         firebaseWizard.getAllTolls { [weak self] tolls, error in
             guard let self = self else { return }
             defer {
                 self.isFetchingLocations = false
             }
             if let error = error {
                 print("Error fetching tolls: \(error)")
             } else if let tolls = tolls {
                 UserDefaultsManager.setCachedTolls(tolls)
                 self.allTolls = tolls
             }
         }
     }

    func getAllLocations(completion: @escaping ([LocationModel]) -> Void) {
      
            fetchAllLocations()
            var attempts = 0
            let maxAttempts = 5
            let fetchInterval: TimeInterval = 1
            Timer.scheduledTimer(withTimeInterval: fetchInterval, repeats: true) { timer in
                attempts += 1
                if !self.allLocations.isEmpty || attempts >= maxAttempts {
                    timer.invalidate()
                    completion(self.allLocations)
                }
            }
        }
}
     
extension Array where Element == LocationModel {
    func filterLocations(byCategory category: String) -> [LocationModel] {
        return self.filter { $0.category.contains(category)}
    }
}
extension Array where Element == LocationModel {
    func filterLocations(byCategories categories: [String]) -> [LocationModel] {
        return self.filter { location in
            location.category.contains { categories.contains($0) }
        }
    }
}

