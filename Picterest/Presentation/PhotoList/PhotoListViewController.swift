//
//  ViewController.swift
//  Picterest
//

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
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

extension PhotoListViewController: CellActionDelegate {
    // TODO: [] alert class 따로 만들기
    func starButtonTapped(cell: PhotoListCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.item]
        let imageID = photo.id
        let imageURL = photo.urls.small
        let imageWidth = photo.width
        let imageHeight = photo.height
        let localImagePath = ImageManager.shared.getImagePath(id: imageID)
        let alert = UIAlertController(
            title: "사진 메모",
            message: "",
            preferredStyle: .alert
        )
        
        let saveButton = UIAlertAction(
            title: "저장",
            style: .default) {_ in
            if let textField = alert.textFields?.first,
               let text = textField.text {
                self.URLImageProvider?.fetchImage(from: imageURL, completion: { result in
                    switch result {
                        
                    case .success(let image):
                        let imageSaved = ImageManager.shared.saveImage(
                            id: imageID,
                            image: image
                        )
                        
                        if imageSaved {
                            cell.starButton.isSelected = true
                            CoreDataManager.shared.save(
                                id: imageID,
                                imagePath: localImagePath,
                                imageURL: imageURL,
                                memo: text,
                                width: imageWidth,
                                height: imageHeight
                            )
                        } else {
                            cell.starButton.isSelected = false
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            )}
        }
        
        let cancelButton = UIAlertAction(
            title: "취소",
            style: .destructive,
            handler: nil
        )
        
        alert.addTextField { textField in
            textField.placeholder = "메모를 입력해주세요."
        }
        alert.addAction(cancelButton)
        alert.addAction(saveButton)
        
        self.present(alert, animated: true)
        
    }
    
}
