//
//  PinchCollectionViewCell.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 6.4.24..
//

import UIKit

class PinchCollectionViewCell: UICollectionViewCell,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var zoomableImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.maximumZoomScale = 4
           scrollView.minimumZoomScale = 1
            
           scrollView.delegate = self
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomableImage
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = zoomableImage.image {
                let imageViewSize = zoomableImage.frame.size
                let scrollViewSize = scrollView.bounds.size

                let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
                let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

                scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
