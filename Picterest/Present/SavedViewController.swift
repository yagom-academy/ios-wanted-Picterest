//
//  SavedViewController.swift
//  Picterest
//
//  Created by dong eun shin on 2022/07/30.
//

import UIKit

class SavedViewController: UIViewController {

    var savedImageList: [ImageModel] = []

    @IBOutlet weak var savedCollectioinView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.savedCollectioinView.reloadData()
    }
    
}

extension SavedViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.savedImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.identifier,
            for: indexPath
        ) as! CollectionViewCell
        let info = savedImageList[indexPath.row]
        cell.indexLabel.text = ""
        let urlString = info.imageURL
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            DispatchQueue.main.sync {
                cell.imageView.image = UIImage(data: data)
            }
        }.resume()
        return cell
  }
        
}
extension SavedViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = (view.bounds.width - 4) / 2
        let imageHeight = savedImageList[indexPath.item].height
        let imageWidth = savedImageList[indexPath.item].width
        let imageRatio = imageHeight/imageWidth
        return CGFloat(imageRatio) * cellWidth
    }
}
