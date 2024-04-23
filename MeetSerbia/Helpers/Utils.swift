//
//  Utils.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 6.4.24..
//

import Foundation
import UIKit
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation


class Utils {
    func loadingText() -> String {
        switch UserDefaultsManager.language {
        case "cir":
            return "Учитавање ..."
        case "eng":
            return "Loading ..."
        case "lat":
            return "Učitavanje ..."
        default:
            return "Учитавање ..."
        }
        
    }
    func addNewMemoryText() -> String {
        switch UserDefaultsManager.language {
        case "cir":
            return "ДОДАЈ НОВУ УСПОМЕНУ"
        case "eng":
            return "ADD NEW MEMORY"
        case "lat":
            return "DODAJ NOVU USPOMENU."
        default:
            return "ДОДАЈ НОВУ УСПОМЕНУ"
        }
    }
    
    func startNavigationText() -> String {
        switch UserDefaultsManager.language {
        case "cir":
            return "Започни навигацију"
        case "eng":
            return "Start Navigation"
        case "lat":
            return "Započni navigaciju"
        default:
            return "Започни навигацију"
        }
        
    }
    
    func getPinForCategory(category: String) -> String {
        switch category.lowercased() {
        case "priroda":
            return "nature_pin"
        case "banje":
            return "spa_pin"
        case "gradovi":
            return "city_pin"
        case "građevine":
            return "buildings_pin"
        case "kultura":
            return "culture_pin"
        case "zanimljivosti":
            return "interesting_pin"
        case "sport, rekreacija":
            return "sports_pin"
        case "turist-info centri":
            return "info_pin"
        case "smeštaj":
            return "accomodation_pin"
        case "ugostiteljstvo":
            return "food_pin"
        case "šoping":
            return "shopping_pin"
        case "korisne informacije":
            return "usefull_pin"
            
            
        default:
            return "pin"
        }
    }

    }

