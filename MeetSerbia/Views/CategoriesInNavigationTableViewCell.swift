//
//  CategoriesInNavigationTableViewCell.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 10.6.24..
//

import UIKit
protocol NavigationFilterTapped: AnyObject {
    func buttonTapped(in cell: CategoriesInNavigationTableViewCell)
}
class CategoriesInNavigationTableViewCell: UITableViewCell {
    var cellChecked = false
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var categoryNameLabel: UILabel!
    weak var delegate: NavigationFilterTapped?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        checkButton.setBackgroundImage(UIImage(systemName: "squareshape"), for: .normal)
    }
    
    @IBAction func checkButtonClick(_ sender: Any) {
       
        
        delegate?.buttonTapped(in: self)
    }
    
}
