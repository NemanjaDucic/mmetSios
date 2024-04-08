//
//  HorizontalCollectionViewCell.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 29.8.23..
//

import UIKit
protocol SubcategorySelectedDelegate: AnyObject {
    func buttonTapped(in cell: HorizontalCollectionViewCell)
}
    
class HorizontalCollectionViewCell: UICollectionViewCell {
    var cellData = false 
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var hiddenlabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var overlayImageView: UIImageView!
    weak var delegate: SubcategorySelectedDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        overlayImageView = UIImageView(frame: self.contentView.frame)
        overlayImageView.contentMode = .scaleToFill
        overlayImageView.clipsToBounds = true
        overlayImageView.image = UIImage(named: "shadow")
        overlayImageView.alpha = 0.9
        
        
        hiddenlabel.isHidden = true
        let imageName = cellData ? "button_checked" : "button_unchecked"

        checkButton.setImage(UIImage(named: imageName), for: .normal)
        mainImage.addSubview(overlayImageView)
    }

    
    @IBAction func checkbuttonClick(_ sender: Any) {
        cellData = !cellData
    
        delegate?.buttonTapped(in: self)
        let imageName = cellData ? "button_checked" : "button_unchecked"
        
        checkButton.setImage(UIImage(named: imageName), for: .normal)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // Adjust the frame of overlayImageView here
        overlayImageView.frame = bounds
    }
}
