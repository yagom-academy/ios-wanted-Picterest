//
//  PhotosViewController.swift
//  Picterest
//
//  Created by rae on 2022/07/25.
//

import UIKit
import Combine

protocol PhotosViewControllerDelegate: AnyObject {
    func photoSaveSuccess()
}

final class PhotosViewController: UIViewController {
    
    // MARK: - Properties
    
    enum Section {
        case main
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: pinterestLayout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var pinterestLayout: PinterestLayout = {
        let layout = PinterestLayout()
        layout.delegate = self
        return layout
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Photo>?
    
    private let photosViewModel: PhotosViewModel
    
    private var cancellable = Set<AnyCancellable>()
    
    weak var delegate: PhotosViewControllerDelegate?
    
    // MARK: - init Method
    
    init(photosViewModel: PhotosViewModel) {
        self.photosViewModel = photosViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        photosViewModel.fetch()
    }
    
    // MARK: - Configure Method

    private func configure() {
        configureView()
        configureNavigation()
        addSubviews()
        makeConstraints()
        bind()
        configureDataSource()
    }
}

// MARK: - UI Method

extension PhotosViewController {
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigation() {
        navigationItem.title = "Unsplash"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
    }
    
    private func makeConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Photo>(collectionView: collectionView, cellProvider: { collectionView, indexPath, photo in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return .init()
            }
            
            cell.configureCell(indexPath: indexPath, photo: photo)
            cell.delegate = self
            return cell
        })
    }
}

// MARK: - bind Method

extension PhotosViewController {
    private func bind() {
        photosViewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { photos in
                var snapShot = NSDiffableDataSourceSnapshot<Section, Photo>()
                snapShot.appendSections([Section.main])
                snapShot.appendItems(photos)
                self.pinterestLayout.update(numberOfItems: snapShot.numberOfItems)
                self.dataSource?.apply(snapShot, animatingDifferences: false)
            }
            .store(in: &cancellable)
        
        photosViewModel.$photoSaveSuccessTuple
            .receive(on: DispatchQueue.main)
            .sink { photoSaveSuccessTuple in
                guard let success = photoSaveSuccessTuple.success, let indexPath = photoSaveSuccessTuple.indexPath else {
                    return
                }
                if success {
                    guard let photo = self.dataSource?.itemIdentifier(for: indexPath) else {
                        return
                    }
                    
                    guard var snapShot = self.dataSource?.snapshot() else {
                        return
                    }
                    snapShot.reloadItems([photo])
                    self.dataSource?.apply(snapShot, animatingDifferences: false)
                    self.delegate?.photoSaveSuccess()
                } else {
                    let alertController = UIAlertController(title: "사진 저장 실패", message: "동일한 사진이 존재합니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alertController, animated: true)
                }
            }
            .store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDelegate

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == photosViewModel.photosCount() - 1 {
            photosViewModel.fetch()
        }
    }
}

// MARK: - PinterestLayoutDelegate

extension PhotosViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let cellWidth: CGFloat = (view.bounds.width - 4) / 2
        let imageHeight: CGFloat = CGFloat(photosViewModel.photo(at: indexPath.item).height)
        let imageWidth: CGFloat = CGFloat(photosViewModel.photo(at: indexPath.item).width)
        let imageRatio = imageHeight / imageWidth
        
        return imageRatio * cellWidth
    }
}

// MARK: - PhotoCollectionViewCellDelegate

extension PhotosViewController: PhotoCollectionViewCellDelegate {
    func cellStarButtonClicked(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "메모 입력", message: "\(indexPath.item + 1)번째 사진을 추가하시겠습니까?", preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.photosViewModel.savePhotoResponse(indexPath: indexPath, memo: alertController.textFields?.first?.text ?? "")
        }))
        self.present(alertController, animated: true)
    }
}

// MARK: - SavedViewControllerDelegate

extension PhotosViewController: SavedViewControllerDelegate {
    func photoDeleteSuccess() {
        guard var snapShot = self.dataSource?.snapshot() else {
            return
        }

        snapShot.reloadSections([Section.main])
        dataSource?.apply(snapShot)
    }
}
