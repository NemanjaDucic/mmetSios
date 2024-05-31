//
//  PreviewImageViewController.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 13.6.23..
//

import Foundation
import UIKit
import Kingfisher
import ImageScrollView

class PreviewImageViewController:UIViewController,UIScrollViewDelegate{
    @IBOutlet weak var scroll: ImageScrollView!

    var setImage: UIImage?
    var imagesArray = [String]()
    var num = 0
    var araayOfImages = [UIImage]()
    let buttonLeft = UIButton(type: .custom)
    let buttonRight = UIButton(type: .custom)
    var landscapeConstraints: [NSLayoutConstraint] = []
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscape, .landscapeRight, .landscapeLeft]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.setup()
        scroll.imageScrollViewDelegate = self
        scroll.display(image: setImage!)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeftGesture.direction = .left
        scroll.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRightGesture.direction = .right
        scroll.addGestureRecognizer(swipeRightGesture)
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
                view.addSubview(buttonRight)
                view.addSubview(buttonLeft)
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
            buttonLeft.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonLeft.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonLeft.widthAnchor.constraint(equalToConstant: 60),
            buttonLeft.heightAnchor.constraint(equalToConstant: 60),
            
            buttonRight.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonRight.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonRight.widthAnchor.constraint(equalToConstant: 60),
            buttonRight.heightAnchor.constraint(equalToConstant: 60)
        ])
//        scroll.zoomView?.addSubview(buttonRight)
//        scroll.zoomView?.bringSubviewToFront(buttonRight)
//        scroll.zoomView?.bringSubviewToFront(buttonLeft)
//        scroll.zoomView?.addSubview(buttonLeft)

        
    }
    

    @objc func handleSwipeLeft() {
        guard num > 0 else { return }
        num -= 1
        scroll.display(image: araayOfImages[num])
        
    }
    
    @objc func handleSwipeRight() {
        guard num < araayOfImages.count - 1 else { return }
        num += 1
        scroll.display(image: araayOfImages[num])
    }
}
extension PreviewImageViewController: ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView) {
        view.layoutIfNeeded()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming at scale \(scale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
    }
}


 


    
//    private func centerContentInScrollView() {
//        let xOffset = max(0, (scroll.bounds.width - scroll.contentSize.width) * 0.5)
//        let yOffset = max(0, (scroll.bounds.height - scroll.contentSize.height) * 0.5)
//        image.frame.origin = CGPoint(x: xOffset, y: yOffset)
//    }

//
//
//        buttonRight.setTitle("", for: .normal)
//        buttonRight.setTitleColor(.white, for: .normal)
//        buttonRight.backgroundColor = .clear
//        buttonRight.translatesAutoresizingMaskIntoConstraints = false
//        buttonRight.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
//        buttonRight.addTarget(self, action: #selector(handleSwipeRight), for: .touchUpInside)
//        buttonLeft.addTarget(self, action: #selector(handleSwipeLeft), for: .touchUpInside)
//        buttonLeft.tintColor = .white
//        buttonRight.tintColor = .white
//        image.addSubview(buttonRight)
//        image.addSubview(buttonLeft)
//        let buttonSize: CGFloat = 40 // Set the desired button size
//        buttonLeft.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
//        buttonLeft.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
//
//        buttonRight.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
//        buttonRight.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
//        buttonLeft.imageView?.contentMode = .scaleAspectFit
//        buttonRight.imageView?.contentMode = .scaleAspectFit
//        var config = UIButton.Configuration.filled()
//          config.imagePadding = 40
//        buttonRight.configuration = config
//        buttonLeft.configuration = config
//        NSLayoutConstraint.activate([
//            buttonLeft.centerYAnchor.constraint(equalTo: image.centerYAnchor),
//            buttonLeft.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 16),
//            buttonLeft.widthAnchor.constraint(equalToConstant: 60),
//            buttonLeft.heightAnchor.constraint(equalToConstant: 60),
//
//            buttonRight.centerYAnchor.constraint(equalTo: image.centerYAnchor),
//            buttonRight.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -16),
//            buttonRight.widthAnchor.constraint(equalToConstant: 60),
//            buttonRight.heightAnchor.constraint(equalToConstant: 60)
//        ])
//
