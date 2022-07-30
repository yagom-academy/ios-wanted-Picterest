//
//  HomeViewController.swift
//  Picterest
//
//  Created by dong eun shin on 2022/07/30.
//

import UIKit

import CoreData

class HomeViewController: UIViewController {

    var imageList: [ImageEntity] = []
    var imageModelList : [ImageModel] = []

    @IBOutlet weak var HomeCollectionView: UICollectionView!
    
    @IBAction func tapStarBttn(_ sender: UIButton) {
        imageModelList[sender.tag].isSaved = true
        if sender.isSelected {
            return
        }else{
            sender.isSelected = true
        }
        self.setAlert(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customLayout = CustomLayout()
        customLayout.delegate = self
        HomeCollectionView?.collectionViewLayout = customLayout
        
        let networkService: Api = NetworkService()
        networkService.request { result in
            switch result {
            case .success(let data):
                self.imageList = data as! [ImageEntity]
                self.imageList.forEach { entity in
                    self.imageModelList.append(ImageModel(imageURL: entity.imageURL.thumbnail, width: entity.width, height: entity.height, isSaved: false))
                }
                DispatchQueue.main.sync {
                    self.HomeCollectionView.reloadData()
                }
            case .failure(let error):
                print("ERROR: ", error)
            }
        }
    }

    func setAlert(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "⚠️",
            message: "⚡️메세지가 이미지와 함께 저장됩니다.⚡️",
            preferredStyle: .alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: .default) { (ok) in
                let name = alert.textFields?[0].text ?? UUID().uuidString
                guard let path = FileSaveManager.shared.saveImage(image: (sender.imageView?.image)!, name: name) else { return }
                let item = self.imageModelList[sender.tag]
                self.saveItem(name: name, path: path, url: item.imageURL, memo: name, height: item.height, width: item.width)
//                let a = FileSaveManager.shared.getSavedImage(named: name)
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
        alert.addTextField { (myTextField) in
            myTextField.placeholder = "여기에 메세지를 입력해 주세요."
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveItem(name: String, path: String, url: String, memo: String, height: Int, width: Int) {
        CoreDataManager.shared.createItem(name: name, path: path, url: url, memo: memo, height: Int64(height), width: Int64(width)) {
            print("Saved in CoreData")
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.identifier,
            for: indexPath
        ) as! CollectionViewCell
        cell.downloadBttn.tag = indexPath.row
        cell.indexLabel.text = "\(indexPath.row + 1)번째"
        let info = imageList[indexPath.row]
        let urlString = info.imageURL.thumbnail
        if cell.imageView.setImageUrl(urlString){
            cell.downloadBttn.isSelected = true
        }
        return cell
  }
}

extension HomeViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = (view.bounds.width - 4) / 2
        let imageHeight = imageList[indexPath.item].height
        let imageWidth = imageList[indexPath.item].width
        var imageRatio = 0
        if imageHeight < imageWidth{
            imageRatio = imageWidth / imageHeight
        }else {
            imageRatio = imageHeight / imageWidth
        }
        return CGFloat(imageRatio) * cellWidth
    }
}
