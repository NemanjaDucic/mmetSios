//import UIKit
//import MapboxSearch
//
//class TextViewLoggerViewController: UIViewController {
//    let responseTextView = UITextView()
//    
//    func logUI(_ message: String) {
//        responseTextView.text = message
//    }
//    
//    func dumpSuggestions(_ suggestions: [SearchSuggestion], query: String) {
//        print("Number of search results: \(suggestions.count) for query: \(query)")
//        let headerText = " број подударности: \(suggestions.count)"
//        
//        let suggestionsLog = suggestions.map { suggestion in
//            var suggestionString = "\(suggestion.name)"
//            if let description = suggestion.descriptionText {
//                suggestionString += "\n\tdescription: \(description)"
//            } else if let address = suggestion.address?.formattedAddress(style: .medium) {
//                suggestionString += "\n\taddresa: \(address)"
//            }
//            if let distance = suggestion.distance {
//                suggestionString += "\n\tdistanca: \(Int(distance / 1000)) km"
//            }
//            return suggestionString + "\n"
//        }.joined(separator: "\n")
//        
//        logUI(headerText + "\n\n" + suggestionsLog)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        responseTextView.isEditable = false
//        view.addSubview(responseTextView)
//        responseTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
//
//        addConstraints()
//    }
//    
//    func addConstraints() {
//        let textViewConstraints = [
//            responseTextView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//            responseTextView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//            responseTextView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -300),
//            responseTextView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 130)
//        ]
//        responseTextView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate(textViewConstraints)
//    }
//
//}
