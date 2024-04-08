//
//  PreviewImageViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 13.6.23..
//

import Foundation
import UIKit
import Kingfisher

class PreviewImageViewController:UIViewController,UIScrollViewDelegate{
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    var setImage: UIImage?
    var imagesArray = [String]()
    var num = 0
    var araayOfImages = [UIImage]()
    let buttonLeft = UIButton(type: .custom)
    let buttonRight = UIButton(type: .custom)
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.delegate = self
        image.image = setImage
        image.isUserInteractionEnabled = true
     
        
        buttonLeft.setTitle("", for: .normal)
        buttonLeft.setTitleColor(.white, for: .normal)
        buttonLeft.backgroundColor = .clear
        buttonLeft.translatesAutoresizingMaskIntoConstraints = false
        buttonLeft.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        buttonRight.setTitle("", for: .normal)
        buttonRight.setTitleColor(.white, for: .normal)
        buttonRight.backgroundColor = .clear
        buttonRight.translatesAutoresizingMaskIntoConstraints = false
        buttonRight.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        buttonRight.addTarget(self, action: #selector(handleSwipeRight), for: .touchUpInside)
        buttonLeft.addTarget(self, action: #selector(handleSwipeLeft), for: .touchUpInside)
        buttonLeft.tintColor = .white
        buttonRight.tintColor = .white
        image.addSubview(buttonRight)
        image.addSubview(buttonLeft)
        let buttonSize: CGFloat = 40 // Set the desired button size
        buttonLeft.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        buttonLeft.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true

        buttonRight.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        buttonRight.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        buttonLeft.imageView?.contentMode = .scaleAspectFit
        buttonRight.imageView?.contentMode = .scaleAspectFit
        var config = UIButton.Configuration.filled()
          config.imagePadding = 40
        buttonRight.configuration = config
        buttonLeft.configuration = config
        NSLayoutConstraint.activate([
            buttonLeft.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            buttonLeft.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 16),
            buttonLeft.widthAnchor.constraint(equalToConstant: 60),
            buttonLeft.heightAnchor.constraint(equalToConstant: 60),
            
            buttonRight.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            buttonRight.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -16),
            buttonRight.widthAnchor.constraint(equalToConstant: 60),
            buttonRight.heightAnchor.constraint(equalToConstant: 60)
        ])
      

    
        
    
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return image
    }
    @objc func handleSwipeLeft() {
        guard num > 0 else {
        return
       }
       
       num = num - 1
        image.image = araayOfImages[num]
    }

    @objc func handleSwipeRight() {
        guard num < araayOfImages.count - 1 else {
            return
        }
        
        num = num + 1
        image.image = araayOfImages[num]
    }


}

