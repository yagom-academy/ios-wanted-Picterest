//
//  PhotoSaveViewController.swift
//  Picterest
//
//

import UIKit

class PhotoSaveViewController: UIViewController {
    @IBOutlet weak var saveListCollectionView: UICollectionView!
    
    var coreData = [Picterest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreData = CoreDataManager.shared.fetchCoreData()
        saveListCollectionView.reloadData()
    }
}

//MARK: - Methods

extension PhotoSaveViewController {
    
}

//MARK: - Extension: CollectionView

extension PhotoSaveViewController {
    private func setCollectionView() {
        saveListCollectionView.dataSource = self
        saveListCollectionView.delegate = self
        saveListCollectionView?.contentInset = UIEdgeInsets(
            top: 10,
            left: 16,
            bottom: 10,
            right: 16
        )
        saveListCollectionView.register(
            UINib(
                nibName: "PhotoSaveCollectionViewCell",
                bundle: nil
            ),
            forCellWithReuseIdentifier: "PhotoSaveCollectionViewCell"
        )
        let flowlayout = UICollectionViewFlowLayout()
        saveListCollectionView.collectionViewLayout = flowlayout
    }
}

extension PhotoSaveViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return coreData.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let saveCell = saveListCollectionView.dequeueReusableCell(
            withReuseIdentifier: "PhotoSaveCollectionViewCell",
            for: indexPath
        ) as? PhotoSaveCollectionViewCell else {
            return UICollectionViewCell()
        }
        saveCell.deleteSavedData = {
            ImageFileManager.shared.deleteImageFromLocal(named: self.coreData[indexPath.row].id ?? "")
            CoreDataManager.shared.deleteCoreData(ID: self.coreData[indexPath.row].id ?? "")
        }
        saveCell.savedMemo.text = coreData[indexPath.row].memo
        saveCell.fetchDataFromCollectionView(data: coreData[indexPath.row].url ?? "")
        return saveCell
    }
}

extension PhotoSaveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = UIScreen.main.bounds.width - 32
        let height =  width * (coreData[indexPath.row].heigt / coreData[indexPath.row].width)
        return CGSize(width: width, height: height)
    }
}
