//
//  DataModel.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 24.3.23..
//


import Foundation

class DataModel:Equatable{
    var category: String = ""
    var categoryEng:String = ""
    var categoryLat:String = ""
    var subcategory: [String] = []
    var subcategoryLat:[String] = []
    var subcategoryEng:[String] = []
    var expanded: Bool = false
    var categoryImageData : String = ""
    var imageData : [String] = []
    
    init(category: String,categoryEng:String,categoryLat:String, subcategory: [String],subcategotyLat:[String],subcategoryEng:[String], expanded:Bool,categoryImageData:String,imageData:[String]) {
        self.category = category
        self.categoryEng = categoryEng
        self.categoryLat = categoryLat
        self.subcategory = subcategory
        self.subcategoryLat = subcategotyLat
        self.subcategoryEng = subcategoryEng
        self.expanded = expanded
        self.categoryImageData = categoryImageData
        self.imageData = imageData
    }
    static func == (lhs: DataModel, rhs: DataModel) -> Bool {
        // Compare each property of the instances
        return lhs.category == rhs.category &&
               lhs.categoryEng == rhs.categoryEng &&
               lhs.categoryLat == rhs.categoryLat &&
               lhs.subcategory == rhs.subcategory &&
               lhs.subcategoryLat == rhs.subcategoryLat &&
               lhs.subcategoryEng == rhs.subcategoryEng &&
               lhs.expanded == rhs.expanded &&
               lhs.categoryImageData == rhs.categoryImageData &&
               lhs.imageData == rhs.imageData
    }
}
    
