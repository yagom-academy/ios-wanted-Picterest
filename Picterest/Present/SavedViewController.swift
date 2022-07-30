//
//  SavedViewController.swift
//  Picterest
//
//  Created by dong eun shin on 2022/07/30.
//

import UIKit

import CoreData

class SavedViewController: UIViewController {

    var savedImageList: [Entity] = []

    @IBAction func TapStarBttn(_ sender: UIButton) {
        sender.isSelected = false
        self.setAlert(sender)
    }
    
    @IBOutlet weak var savedCollectioinView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customLayout = CustomLayout()
        customLayout.delegate = self
        savedCollectioinView?.collectionViewLayout = customLayout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        CoreDataManager.shared.fatchItem(completion: { entityList in
            self.savedImageList = entityList
            
            print(self.savedImageList)
            self.savedCollectioinView.reloadData()
        })
    }
    
    func setAlert(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "⚠️",
            message: "사진을 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: .default) { (ok) in
                self.deleteImage(sender: sender)
        }
        let cancel = UIAlertAction(
            title: "cancel",
            style: .cancel
        ) { (cancel) in
            if sender.isSelected {
                sender.isSelected = false
            }else{
                sender.isSelected = true
            }
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

extension SavedViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("<<<",self.savedImageList.count)
        return self.savedImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.identifier,
            for: indexPath
        ) as! CollectionViewCell
        cell.backgroundColor = .blue
        let info = savedImageList[indexPath.row]
        cell.downloadBttn.isSelected = true
        cell.indexLabel.text = savedImageList[indexPath.row].memo
        guard let urlString = info.url else { return CollectionViewCell() }
        let _ = cell.imageView.setImageUrl(urlString)
        return cell
    }
    
    @objc func deleteImage(sender: UIButton){
        self.savedCollectioinView.deleteItems(at: [IndexPath.init(row: sender.tag, section: 0)])
        CoreDataManager.shared.delete(entity: savedImageList[sender.tag])
        self.savedImageList.remove(at: sender.tag)
    }
}

extension SavedViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = (view.bounds.width - 4) / 2
//        print(savedImageList[indexPath.item])
        let imageHeight = savedImageList[indexPath.item].height
        let imageWidth = savedImageList[indexPath.item].width
        var imageRatio = 0
        if imageHeight < imageWidth{
            imageRatio = Int(imageWidth / imageHeight)
        }else {
            imageRatio = Int(imageHeight / imageWidth)
        }
        return CGFloat(imageRatio) * cellWidth
    }
}
