import UIKit
import Foundation
import FirebaseDatabase

class VCadd: UIViewController{
    
    
    @IBOutlet weak var cirname: UITextField!
    
    @IBOutlet weak var latname: UITextField!
    
    @IBOutlet weak var longlong: UITextField!
    @IBOutlet weak var latlat: UITextField!
    @IBOutlet weak var engname: UITextField!
    private let refrence = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonclicked(_ sender: Any) {
        let randomId = NSUUID().uuidString.lowercased()
        let memory = ["nameCir":cirname.text!,"nameLat":latname.text!,"nameEng":engname.text!, "lat":latlat.text!,"long":longlong.text!]
        refrence.child("tolls").child(randomId).setValue(memory)
    }
    
}
