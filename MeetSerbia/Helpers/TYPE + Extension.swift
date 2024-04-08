//
//  TYPE + Extension.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 22.3.24..
//

import Foundation

extension Array where Element: Equatable {
    mutating func toggle(element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        } else {
            append(element)
        }
    }
}
