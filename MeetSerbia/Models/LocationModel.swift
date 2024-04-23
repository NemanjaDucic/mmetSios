//
//  LocationModel.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 20.3.23..
//

import Foundation


struct LocationModel: Codable {
    var category: [String]
    let descriptionCir: String
    let descriptionEng: String
    let descriptionLat: String
    let id: String
    let images: [String]
    let video: String
    let lat: Double
    let lon: Double
    let subcat: [String]
    let nameCir: String
    let nameEng: String
    let nameLat: String
    var primaryCategory: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decodeIfPresent([String].self, forKey: .category) ?? []
        descriptionCir = try container.decodeIfPresent(String.self, forKey: .descriptionCir) ?? ""
        descriptionEng = try container.decodeIfPresent(String.self, forKey: .descriptionEng) ?? ""
        descriptionLat = try container.decodeIfPresent(String.self, forKey: .descriptionLat) ?? ""
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        images = try container.decodeIfPresent([String].self, forKey: .images) ?? []
        video = try container.decodeIfPresent(String.self, forKey: .video) ?? ""
        lat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0.0
        lon = try container.decodeIfPresent(Double.self, forKey: .lon) ?? 0.0
        subcat = try container.decodeIfPresent([String].self, forKey: .subcat) ?? []
        nameCir = try container.decodeIfPresent(String.self, forKey: .nameCir) ?? ""
        nameEng = try container.decodeIfPresent(String.self, forKey: .nameEng) ?? ""
        nameLat = try container.decodeIfPresent(String.self, forKey: .nameLat) ?? ""
        primaryCategory = try container.decodeIfPresent(String.self, forKey: .primaryCategory) ?? ""
    }

    func toDictionary() -> [String: Any] {
        return [
            "category": category,
            "descriptionCir": descriptionCir,
            "descriptionEng": descriptionEng,
            "descriptionLat": descriptionLat,
            "id": id,
            "images": images,
            "lat": lat,
            "lon": lon,
            "nameCir": nameCir,
            "nameEng": nameEng,
            "nameLat": nameLat,
            "subcat": subcat,
            "video": video,
            "primaryCategory": primaryCategory
        ]
    }
}
