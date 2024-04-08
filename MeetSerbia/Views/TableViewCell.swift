//
//  TableViewCell.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 24.3.23..
//

import UIKit


protocol SelectedCategoryDelegate: AnyObject {
    func didSelectCategory(cell: UITableViewCell, category: String,index:Int)
}



class TableViewCell: UITableViewCell,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var imageHolder: UIImageView!
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var hidencell: UILabel!
    @IBOutlet weak var holderTView: UITableView!
    @IBOutlet weak var testLabel: VerticalAlignedLabel!
    var data = [String]()
    var inviData = [String]()
    weak var delegate: SelectedCategoryDelegate?

    @IBOutlet weak var categoryCheckButton: UIButton!
    var imageData = [String]()
    var allData = [DataModel]()
    var vc = UIViewController()
    var index:Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        hidencell.isHidden = true
        
        // Configure the tableView
        holderTView.delegate = self
        holderTView.dataSource = self
        holderTView.register(UINib(nibName: "HomePageTableViewCell", bundle: nil), forCellReuseIdentifier: "homePageCell")
        holderTView.reloadData()
        categoryCheckButton.setImage(UIImage(named: "button_unchecked"), for: .normal)

        let imageView = UIImageView(frame: (self.imageHolder.bounds))
                  imageView.contentMode = .scaleToFill
                  imageView.clipsToBounds = true
                  imageView.image = UIImage(named: "shadow")
                    imageView.alpha = 0.9
                  imageHolder.addSubview(imageView)
     }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = holderTView.dequeueReusableCell(withIdentifier: "homePageCell", for: indexPath) as! HomePageTableViewCell
        if data != [String](){
            cell.textLabel?.text = data[indexPath.row].uppercased()
            cell.textLabel?.font = UIFont(name:"Arial",size: 32)
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.textColor = .white
            cell.selectionStyle = .none
            let backgroundImageView = UIImageView(image: UIImage(named: imageData[indexPath.row]))
            
            cell.backgroundView = backgroundImageView
            
        }
        

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController =  UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FMT") as? FilteredMapViewController
//        viewController?.subCategory = inviData[indexPath.row].lowercased()
        vc.dismiss(animated: true)
        vc.navigationController?.pushViewController(viewController!, animated: true)
        print(data.count)
        
      
    }
   
    @IBAction func categoryCheckButtonClick(_ sender: Any) {
        if (categoryCheckButton.image(for: .normal) == UIImage(named: "button_unchecked")){
            categoryCheckButton.setImage(UIImage(named: "button_checked"), for: .normal)
        } else {
            categoryCheckButton.setImage(UIImage(named: "button_unchecked"), for: .normal)

        }
        delegate?.didSelectCategory(cell: self, category: hidencell.text?.lowercased() ?? "",index: index ?? 0)

    }
}
