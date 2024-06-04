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
extension String {
    var htmlToAttributedStringWithIncreasedFontSize: NSAttributedString? {
        // Replace the specific URL with the new URL
        let modifiedHtmlString = self.replacingOccurrences(of: "https://mts.rs/Privatni/Korisnicka-zona/Kontakt/Kako-do-nas", with: "https://mts.rs")
        
        guard let data = modifiedHtmlString.data(using: .utf8) else { return nil }
        do {
            let attributedString = try NSMutableAttributedString(data: data,
                                                                  options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                                                  documentAttributes: nil)
            
            // Increase font size by 4 points
            attributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: attributedString.length), options: []) { value, range, _ in
                if let font = value as? UIFont {
                    let newFont = font.withSize(font.pointSize + 4)
                    attributedString.addAttribute(.font, value: newFont, range: range)
                }
            }
            
            return attributedString
        } catch {
            print("Error creating attributed string from HTML: \(error)")
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedStringWithIncreasedFontSize?.string ?? ""
    }
}







