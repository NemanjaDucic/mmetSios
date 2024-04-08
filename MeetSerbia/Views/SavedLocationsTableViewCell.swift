//
//  SavedLocationsTableViewCell.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 22.3.24..
//

import UIKit
protocol DidSelectLocationDelegate: AnyObject {
    func didClickLocation(index:Int)
}
class SavedLocationsTableViewCell: UITableViewCell {
    var index:Int?
    weak var delegate:DidSelectLocationDelegate?
    @IBOutlet weak var locationNameLabel: UILabel!
        
    @IBOutlet weak var locationImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        locationImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        locationImage.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func forwardButtonClick(_ sender: Any) {
        delegate?.didClickLocation(index: index ?? 0)
    }
    @objc func imageTapped() {
        delegate?.didClickLocation(index: index ?? 0)
    }
}
