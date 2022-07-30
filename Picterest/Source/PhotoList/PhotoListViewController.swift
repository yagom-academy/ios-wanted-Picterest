//
//  PhotoListViewController.swift
//  Picterest
//
//

import UIKit

public var currentPage = 1

class PhotoListViewController: UIViewController {
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    
    private var photoList: [PhotoModel] = []
    private var coreData: [Picterest] = []
    private var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        getPhotoData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataManager.shared.fetchCoreData { [weak self] data in
            self?.coreData = data
        }
        photoListCollectionView.reloadData()
    }
}

//MARK: - Extension: Methods

extension PhotoListViewController {
    private func setCollectionView() {
        photoListCollectionView.delegate = self
        photoListCollectionView.dataSource = self
        if let layout = photoListCollectionView.collectionViewLayout as?
            PhotoListCollectionViewLayout {
            layout.delegate = self
        }
        photoListCollectionView?.contentInset = UIEdgeInsets(
            top: 10,
            left: 16,
            bottom: 10,
            right: 16
        )
        photoListCollectionView.register(
            UINib(
                nibName: PhotoListCollectionViewCell.identifier,
                bundle: nil
            ),
            forCellWithReuseIdentifier: PhotoListCollectionViewCell.identifier
        )
    }
    
    private func getPhotoData() {
        networkManager.getPhotoList(currentPage: currentPage) { [weak self] result in
            switch result {
            case .success(let data):
                self?.photoList.append(contentsOf: data)
                DispatchQueue.main.async {
                    self?.photoListCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Extension: DidTapPhotoSaveButtonDelegate

extension PhotoListViewController: DidTapPhotoSaveButtonDelegate { 
    func didTapPhotoSaveButton(isSelected: Bool, photoInfo: PhotoModel?, image: UIImage?) {
        if isSelected {
            let saveAlert = UIAlertController.presentSaveAndDeleteAlert(
                title: "사진 저장",
                message: "저장할 사진에 메모를 남겨주세요",
                isTextField: true
            ) { alert in
                guard let memo = alert.textFields?.first?.text,
                      let photoInfo = photoInfo,
                      let image = image  else { return }
                guard let urlPath = ImageFileManager.shared.saveImageToLocal(
                    image: image,
                    name: (photoInfo.id) + ".png"
                ) else { return }
                CoreDataManager.shared.saveCoreData(
                    id: photoInfo.id,
                    memo: memo,
                    url:photoInfo.urls.regular,
                    location: urlPath,
                    width: photoInfo.width,
                    height: photoInfo.height
                )
            }
            self.present(saveAlert, animated: true)
        } else {
            let deleteAlert = UIAlertController.presentSaveAndDeleteAlert(
                title: "사진 저장 취소",
                message: "사진 저장이 취소 되었습니다.",
                isTextField: false,
                completion: nil)
            guard let photoInfo = photoInfo else { return }
            ImageFileManager.shared.deleteImageFromLocal(named: (photoInfo.id) + ".png")
            CoreDataManager.shared.deleteCoreData(ID: photoInfo.id)
            self.present(deleteAlert, animated: true)
        }
    }
}

//MARK: - Extension: CollectionViewDataSource, Delegate

extension PhotoListViewController: PhotoListCollectionViewLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        let width = CGFloat(photoList[indexPath.row].width)
        let height = CGFloat(photoList[indexPath.row].height)
        return (((collectionView.frame.width - 32) / 2 ) - 10) * (height /  width)
    }
}

extension PhotoListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photoList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let photoCell = photoListCollectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoListCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoListCollectionViewCell else {
            return UICollectionViewCell()
        }
        var flag = false
        coreData.forEach {
            if $0.id == photoList[indexPath.row].id {
                flag = true
            }
        }
        photoCell.delegate = self
        photoCell.photoInfo = photoList[indexPath.row]
        photoCell.fetchDataFromCollectionView(
            data: photoList[indexPath.row],
            isSelectedFlag: flag
        )
        photoCell.captionLabel.text = "\(indexPath.row)번째 사진"
        return photoCell
    }
}

extension PhotoListViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.row > photoList.count - 2 {
            currentPage += 1
            getPhotoData()
        }
    }
}
