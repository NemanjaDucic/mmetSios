//
//  CustomRoute.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 22.3.24..
//

import Foundation
struct CustomRoute {
    var name: String = ""
    var points: [CoordinateModel] = []
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["name"] = name
        dictionary["points"] = points.map { $0.toDictionary() }
        return dictionary
    }
}
