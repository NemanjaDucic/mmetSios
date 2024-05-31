//
//  UserDefaultsManager.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 6.4.24..
//

import Foundation
class UserDefaultsManager {
    static let userDef = UserDefaults.standard
    static var userID : String {
        get {
            return userDef.string(forKey: "uid") ?? ""
        }
        set {
            userDef.set(newValue, forKey: "uid")
        }
    }
    static var language : String {
        get {
            return userDef.string(forKey: "Language") ?? ""
        }
        set {
            userDef.set(newValue, forKey: "Language")
        }
    }
    static var entryCounter : Int {
        get {
            return userDef.integer(forKey: "counter") 
        }
        set {
            userDef.set(newValue, forKey: "counter")
        }
    }
    static func getDocumentsDirectory() -> URL {
           return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
       }
    static func saveDataToFile(data: Data, fileName: String) {
          let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
          do {
              try data.write(to: fileURL)
              print("Data saved to file \(fileName).")
          } catch {
              print("Error saving data to file \(fileName): \(error)")
          }
      }
    static func loadDataFromFile(fileName: String) -> Data? {
           let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
           do {
               let data = try Data(contentsOf: fileURL)
               return data
           } catch {
               print("Error loading data from file \(fileName): \(error)")
               return nil
           }
       }

    static func getCachedLocations(completion: @escaping ([LocationModel]?) -> Void) {
            if let data = loadDataFromFile(fileName: "CachedLocations.dat") {
                do {
                    let locations = try JSONDecoder().decode([LocationModel].self, from: data)
                    completion(locations)
                } catch {
                    print("Error decoding locations: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    static func setCachedLocations(_ locations: [LocationModel]) {
            do {
                let data = try JSONEncoder().encode(locations)
                saveDataToFile(data: data, fileName: "CachedLocations.dat")
            } catch {
                print("Error encoding locations: \(error)")
            }
        }

        // Function to get cached tolls
        static func getCachedTolls(completion: @escaping ([TollModel]?) -> Void) {
            if let data = loadDataFromFile(fileName: "CachedTolls.dat") {
                do {
                    let tolls = try JSONDecoder().decode([TollModel].self, from: data)
                    completion(tolls)
                } catch {
                    print("Error decoding tolls: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }

        // Function to set cached tolls
        static func setCachedTolls(_ tolls: [TollModel]) {
            do {
                let data = try JSONEncoder().encode(tolls)
                saveDataToFile(data: data, fileName: "CachedTolls.dat")
            } catch {
                print("Error encoding tolls: \(error)")
            }
        }
//    static func getCachedLocations(completion: @escaping ([LocationModel]?) -> Void) {
//            if let data = userDef.data(forKey: "CachedLocations") {
//                do {
//                    let locations = try JSONDecoder().decode([LocationModel].self, from: data)
//                    completion(locations)
//                } catch {
//                    print("Error decoding locations: \(error)")
//                    completion(nil)
//                }
//            } else {
//                completion(nil)
//            }
//        }
//    static func setCachedLocations(_ locations: [LocationModel]) {
//          do {
//              let data = try JSONEncoder().encode(locations)
//              userDef.set(data, forKey: "CachedLocations")
//          } catch {
//              print("Error encoding locations: \(error)")
//          }
//      }
//    static func getCachedTolls(completion: @escaping ([TollModel]?) -> Void) {
//            if let data = userDef.data(forKey: "CachedTolls") {
//                do {
//                    let locations = try JSONDecoder().decode([TollModel].self, from: data)
//                    completion(locations)
//                } catch {
//                    print("Error decoding locations: \(error)")
//                    completion(nil)
//                }
//            } else {
//                completion(nil)
//            }
//        }
//    static func setCachedTolls(_ locations: [TollModel]) {
//          do {
//              let data = try JSONEncoder().encode(locations)
//              userDef.set(data, forKey: "CachedTolls")
//          } catch {
//              print("Error encoding locations: \(error)")
//          }
//      }
}
