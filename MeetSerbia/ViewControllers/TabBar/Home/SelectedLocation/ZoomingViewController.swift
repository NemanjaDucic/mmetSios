import UIKit
import Foundation
import FirebaseDatabase

class ZoomingVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collections.dequeueReusableCell(withReuseIdentifier: "pinchCell", for: indexPath) as! PinchCollectionViewCell
        cell.zoomableImage.image = images[indexPath.row]
        return cell
    }
    

    let images = [UIImage]()

    @IBOutlet weak var collections: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collections.delegate = self
        collections.dataSource = self
        collections.register(UINib(nibName: "PinchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "pinchCell")
        let layout = UICollectionViewFlowLayout()
                          layout.scrollDirection = .horizontal
                          layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
                          layout.itemSize = CGSize(width: view.frame.width, height: collections.frame.height)
        collections.collectionViewLayout = layout
    }
    

 
}
 
    

