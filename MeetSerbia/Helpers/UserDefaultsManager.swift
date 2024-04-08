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
}
