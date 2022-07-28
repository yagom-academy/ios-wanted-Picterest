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
        
        if let layout = collectionView.collectionViewLayout as?  CustomCollectionViewLayout {
            layout.delegate = self
        }
        setupCollectionView()
        setupConstraints()
        
        fetchPhotos()
    }
    
    private func setupCollectionView() {
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

// MARK: - Extensions

extension PhotoListViewController {
    
    private func fetchPhotos() {
        photoListAPIProvider?.fetchPhotoList(completion: { result in
            switch result {
            case .success(let photoLists):
                self.photos += photoLists
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

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
        
        cell.setupCell(photo: photo, index: indexPath.item)
        
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
        photoListAPIProvider?.fetchPhotoList(completion: { result in
            switch result {
            case .success(let photoLists):
                self.photos += photoLists
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}

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
