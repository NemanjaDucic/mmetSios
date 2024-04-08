//
//  SavedRoutesTableViewCell.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 22.3.24..
//

import UIKit
import CoreLocation
protocol SelectedRouteDelegate: AnyObject {
    func didSelectRoute(cell: UITableViewCell, route: Int)
}

class SavedRoutesTableViewCell: UITableViewCell {
    @IBOutlet weak var imageRoute: UIImageView!
    weak var delegate:SelectedRouteDelegate?
    var routeIndex :Int?
    @IBOutlet weak var routeNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageRoute.isUserInteractionEnabled = true
               routeNameLabel.isUserInteractionEnabled = true
//        imageRoute.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        routeNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func buttonForwardClick(_ sender: Any) {
        delegate?.didSelectRoute(cell: self, route: routeIndex ?? 0)
    }
    func configure(index: Int) {
          routeIndex = index
      }
    @objc func imageTapped() {
        delegate?.didSelectRoute(cell: self, route: routeIndex ?? 0)
    }
    
}
