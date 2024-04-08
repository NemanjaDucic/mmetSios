//
//  MemoryModel.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 14.3.23..
//

import Foundation
import UIKit
struct MemoryModel {
    var description :String = ""
    var location : String = ""
    var id:String = ""
    var image: UIImage?
    init(description: String, location: String, id: String,image:UIImage) {
           self.description = description
           self.location = location
           self.id = id
            self.image = image
       }
}
