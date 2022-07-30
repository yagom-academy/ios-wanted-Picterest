//
//  ViewController.swift
//  Picterest
//

import CoreData
import UIKit

protocol CustomCollectionViewLayoutDelegate: AnyObject {
    
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat
    
    func collectionView(
        _ collectionView: UICollectionView,
        widthForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat
    
}

class PhotoListViewController: UIViewController {
    
    // MARK: - UIProperties
    
    private lazy var collectionView: UICollectionView = {
        let layout = CustomCollectionViewLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            PhotoListCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoListCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    // MARK: - Properties
    
    private var photoListAPIProvider: PhotoListAPIProviderType?
    private var URLImageProvider: URLImageProviderType?
    private var photos: [PhotoListResult] = []
    private var savedPhotos: [NSManagedObject] = []
    private var page = 1
    
    // MARK: - LifeCycle
    
    static func instantiate(
        with photoListAPIProvider: PhotoListAPIProviderType,
        _ URLImageProvider: URLImageProviderType
    ) -> PhotoListViewController {
        let viewController = PhotoListViewController()
        viewController.photoListAPIProvider = photoListAPIProvider
        viewController.URLImageProvider = URLImageProvider
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupConstraints()
        fetchPhotos()
        fetchFromCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFromCoreData()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func checkFileExist(id: String) -> Bool {
        guard let localURL = ImageManager.shared.getDirectoryURL() else { return false }
        let localImagePath = localURL.appendingPathComponent(id).path
        
        if FileManager.default.fileExists(atPath: localImagePath) {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - FetchFromCoreData Method extension

extension PhotoListViewController {
    
    private func fetchFromCoreData() {
        savedPhotos = CoreDataManager.shared.load() ?? []
    }
    
}

// MARK: - Layout extension

extension PhotoListViewController {
    
    private func setupCollectionView() {
        if let layout = collectionView.collectionViewLayout as?  CustomCollectionViewLayout {
            layout.delegate = self
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        
        [collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        setupConstraintsOfCollectionView()
    }
    
    private func setupConstraintsOfCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            collectionView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])
    }
    
}

// MARK: - Fetch another page extension

extension PhotoListViewController {
    
    private func fetchPhotos() {
        photoListAPIProvider?.fetchPhotoList(
            with: page,
            completion: { [weak self] result in
            switch result {
                
            case .success(let photoLists):
                self?.photos += photoLists
                self?.page += 1
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

// MARK: - CollectionView DataSource extension

extension PhotoListViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return photos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoListCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoListCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photo: PhotoListResult = photos[indexPath.item]
        let imageURL: String = photos[indexPath.item].urls.small
        
        cell.cellDelegate = self
        cell.setupCell(photo: photo, index: indexPath.item)
        
        if checkFileExist(id: photo.id) {
            cell.starButton.isSelected = true
        } else {
            cell.starButton.isSelected = false
        }
        
        URLImageProvider?.fetchImage(from: imageURL, completion: { result in
            switch result {
                
            case .success(let image):
                cell.setupImage(image)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        return cell
    }
    
}

// MARK: - CollectionView Delegate extension

extension PhotoListViewController: UICollectionViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        photoListAPIProvider?.fetchPhotoList(with: page, completion: { result in
            switch result {
                
            case .success(let photoLists):
                self.photos += photoLists
                self.page += 1
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}

// MARK: - CustomCollectionViewLayoutDelegate extension

extension PhotoListViewController: CustomCollectionViewLayoutDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        return CGFloat(photos[indexPath.item].height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        widthForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        return CGFloat(photos[indexPath.item].width)
    }

}

// MARK: - Save alert extension

extension PhotoListViewController: CellActionDelegate {
    
    func starButtonTapped(cell: PhotoListCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.item]
        let photoID = photo.id
        let photoURL = photo.urls.small
        let photoWidth = photo.width
        let photoHeight = photo.height
        let localImagePath = ImageManager.shared.getImagePath(id: photoID)
        
        let cancelButton = UIAlertAction(
            title: Text.cancel,
            style: .destructive,
            handler: nil
        )
        
        if !cell.starButton.isSelected {
            
            let alert = UIAlertController(
                title: Text.saveAlertTitle,
                message: "",
                preferredStyle: .alert
            )
            
            let saveButton = UIAlertAction(
                title: Text.save,
                style: .default) {_ in
                    if let textField = alert.textFields?.first,
                       let text = textField.text {
                        self.URLImageProvider?.fetchImage(from: photoURL, completion: { result in
                            switch result {
                                
                            case .success(let image):
                                let imageSaved = ImageManager.shared.saveImage(
                                    id: photoID,
                                    image: image
                                )
                                
                                if imageSaved {
                                    cell.starButton.isSelected = true
                                    CoreDataManager.shared.save(
                                        id: photoID,
                                        imagePath: localImagePath,
                                        imageURL: photoURL,
                                        memo: text,
                                        width: photoWidth,
                                        height: photoHeight
                                    )
                                    self.fetchFromCoreData()
                                } else {
                                    cell.starButton.isSelected = false
                                }
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                        )}
                }
            
            alert.addTextField { textField in
                textField.placeholder = Text.memoPlaceholder
            }
            alert.addAction(cancelButton)
            alert.addAction(saveButton)
            
            self.present(alert, animated: true)
            
        } else {
            
            let alert = UIAlertController(
                title: Text.cancelAlertTitle,
                message: Text.cancelAlertMessage,
                preferredStyle: .alert
            )
            let confirmButton = UIAlertAction(
                title: Text.confirm,
                style: .default) { _ in
                    // TODO: [] 추후 리팩토링 꼭하기
                    if let index = self.savedPhotos.firstIndex(where: { ($0.value(forKey: CoreDataKey.id) as? String)!.hasPrefix(photoID) }) {
                        let savedPhoto = self.savedPhotos[index]
                        
                        ImageManager.shared.deleteImage(id: photoID)
                        CoreDataManager.shared.delete(item: savedPhoto)
                        cell.starButton.isSelected = false
                    }
                }
            alert.addAction(cancelButton)
            alert.addAction(confirmButton)
            
            self.present(alert, animated: true)
        }
        
    }
    
}

// MARK: - NameSpaces

extension PhotoListViewController {
    
    private enum Text {
        
        static let saveAlertTitle: String = "사진 메모"
        static let cancelAlertTitle: String = "저장 취소"
        static let cancelAlertMessage: String = "사진 저장을 취소 하시겠습니까?"
        static let confirm: String = "저장취소"
        static let save: String = "저장"
        static let cancel: String = "취소"
        static let memoPlaceholder: String = "메모를 입력해주세요."
        
    }
    
    private enum CoreDataKey {
        
        static let id: String = "id"
        
    }
    
}
