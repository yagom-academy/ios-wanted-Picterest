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
        print(currentPage, "didload")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataManager.shared.fetchCoreData { [weak self] data in
            self?.coreData = data
        }
        photoListCollectionView.reloadData()
        print("will", coreData.count)
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
    
    private func showSaveAlertMessage(completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(
            title: "사진 저장",
            message: "저장할 사진에 메모를 남겨주세요",
            preferredStyle: .alert
        )
        let saveAction = UIAlertAction(title: "저장", style: .default) { _ in
            completion(alertController.textFields?[0].text)
        }
        alertController.addTextField()
        alertController.addAction(saveAction)
        self.present(alertController, animated: true)
    }
    
    private func showDeleteAlertMessage() {
        let alertController = UIAlertController(
            title: "사진 저장 취소",
            message: "사진 저장이 취소 되었습니다.",
            preferredStyle: .alert
        )
        let deleteAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true)
    }
}

//MARK: - Extension: DidTapPhotoSaveButtonDelegate

extension PhotoListViewController: DidTapPhotoSaveButtonDelegate {
    func showSavePhotoAlert(isSelected: Bool, photoInfo: PhotoModel?, image: UIImage?) {
        if isSelected {
            showSaveAlertMessage { memo in
                guard let memo = memo, let photoInfo = photoInfo, let image = image  else { return }
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
        } else {
            guard let photoInfo = photoInfo else { return }
            ImageFileManager.shared.deleteImageFromLocal(named: (photoInfo.id) + ".png")
            CoreDataManager.shared.deleteCoreData(ID: photoInfo.id)
            showDeleteAlertMessage()
        }
    }
}

//MARK: - Extension: CollectionView

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
        print(photoList.count, "photoCount")
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
