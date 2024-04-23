//
//  TYPE + Extension.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 22.3.24..
//

import Foundation
import UIKit

extension Array where Element: Equatable {
    mutating func toggle(element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        } else {
            append(element)
        }
    }
}
//extension String {
//    var htmlToAttributedString: NSAttributedString? {
//        guard let data = data(using: .utf8) else { return nil }
//        do {
//            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            return nil
//        }
//    }
//    var htmlToString: String {
//        return htmlToAttributedString?.string ?? ""
//    }
//}



extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            let mutableAttributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            if containsNumbersOrDashes() {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .byWordWrapping
                mutableAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: mutableAttributedString.length)) 
                mutableAttributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: mutableAttributedString.length))
                
                let regex = try NSRegularExpression(pattern: "(\\d+\\.)(?![^<]*>)", options: [])
                let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
                var offset = 0
                for match in matches {
                    let range = NSRange(location: match.range.lowerBound + offset, length: 1)
                    mutableAttributedString.replaceCharacters(in: range, with: NSAttributedString(string: "\n"))
                    offset -= 1
                }
            }
            return mutableAttributedString
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    private func containsNumbersOrDashes() -> Bool {
        let numbersAndDashesCharacterSet = CharacterSet(charactersIn: "0123456789-")
        return rangeOfCharacter(from: numbersAndDashesCharacterSet) != nil
    }
}



