//
//  CoordinateModel.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 20.3.23..
//

import Foundation
struct CoordinateModel {
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    func toDictionary() -> [String: Any] {
        return ["lat": lat, "lon": lon]
    }
}
