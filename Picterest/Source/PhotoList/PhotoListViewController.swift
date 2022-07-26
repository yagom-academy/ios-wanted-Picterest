//
//  PhotoListViewController.swift
//  Picterest
//
//

import UIKit

class PhotoListViewController: UIViewController {
    
    @IBOutlet weak var photoListCollectionView: UICollectionView!
    private var photoList: [PhotoModel] = []
    private var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        getPhotoData()
    }
}

//MARK: - Extension: Methods
extension PhotoListViewController {
    func setCollectionView() {
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
                nibName: "PhotoListCollectionViewCell",
                bundle: nil
            ),
            forCellWithReuseIdentifier: "PhotoListCollectionViewCell"
        )
    }
    
    func getPhotoData() {
        networkManager.getPhotoList { result in
            switch result {
            case .success(let data):
                self.photoList.append(contentsOf: data)
                DispatchQueue.main.async {
                    self.photoListCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        print(photoList)
    }
    
    func showAlertMessage(completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "사진 저장", message: "저장할 사진에 메모를 남겨주세요", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let saveAction = UIAlertAction(title: "저장", style: .default) { _ in
            completion(alertController.textFields?[0].text)
        }
        alertController.addTextField()
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true)
    }
}
//MARK: - Extension: DidTapPhotoSaveButtonDelegate

extension PhotoListViewController: DidTapPhotoSaveButtonDelegate {
    func showSavePhotoAlert(sender: UIButton, photoInfo: PhotoModel?) {
        if sender.tintColor == .systemYellow {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            sender.tintColor = .white
            // 파일매니저 삭제하는 메소드 추가
            // coreData 삭제
        } else {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            sender.tintColor = .systemYellow
            showAlertMessage { result in
                guard let result = result else { return }
                print(result, photoInfo)
                // 파일매니저 저장 메소드
                
                // 메모 CoreData추가
//                photoInfo?.urls.raw
//                photoInfo?.id
//                result
                
            }
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
        return photoList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let photoCell = photoListCollectionView.dequeueReusableCell(
            withReuseIdentifier: "PhotoListCollectionViewCell",
            for: indexPath
        ) as? PhotoListCollectionViewCell else {
            return UICollectionViewCell()
        }
        photoCell.delegate = self
        photoCell.photoInfo = photoList[indexPath.row]
        photoCell.fetchDataFromCollectionView(data: photoList[indexPath.row])
        photoCell.captionLabel.text = "\(indexPath.row)번째 사진"
        return photoCell
    }
}
