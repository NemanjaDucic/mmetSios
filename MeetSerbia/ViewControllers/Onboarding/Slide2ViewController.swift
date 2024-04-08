//
//  ss.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 10.3.23..
//

import Foundation
import UIKit
class Slide2ViewController: UIViewController {

    
    var index: Int = 0
    
    @IBOutlet weak var tvDesc: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        uiSetup()
        
    }
    private func uiSetup(){
        view.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 228/255, alpha: 1)
        tvDesc.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer\n \n took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing\n \n Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        tvDesc.backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 228/255, alpha: 1)
    }
}
