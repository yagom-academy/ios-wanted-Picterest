//
//  SavedViewController.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/25.
//

import UIKit
import CoreData

class SavedViewController: UIViewController {
    let coreDataService = CoreDataService.shared
    private var imageDatas: [savedModel] = []
    private let imageDownLoader = DownLoadManager()
    
    lazy var collectionView: UICollectionView = {
        let layout = SavedCollectionViewLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            SavedCollectionCustomCell.self,
            forCellWithReuseIdentifier: SavedCollectionCustomCell.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        coreDataService.deleteAll() // 전체 삭제 메서드
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        imageDatas.removeAll()
        if let layout = collectionView.collectionViewLayout as? SavedCollectionViewLayout {
            layout.resetLayout()
        }
        super.viewDidDisappear(animated)
        collectionView.reloadData()
    }
    
    func fetchData() {
        if let datas = coreDataService.fetch() as? [SavedModel] {
            datas.forEach { model in
                let savedModel = savedModel(id: model.id,
                                            memo: model.memo,
                                            file: model.fileURL,
                                            raw: model.rawURL)

                self.imageDatas.append(savedModel)
            }
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - CollectionView DataSource
extension SavedViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return imageDatas.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SavedCollectionCustomCell.identifier,
            for: indexPath
        ) as? SavedCollectionCustomCell else {
            return UICollectionViewCell()
        }
        
        let data = imageDatas[indexPath.row]
        if let image = data.image {
            cell.imageView.image = image.resizeImageTo(newWidth: cell.bounds.width)
        }
        cell.topView.indexLabel.text = data.memoDescription
        
        cell.topView.starButton.isSelected = true
        cell.topView.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.topView.delegate = self
        cell.tag = indexPath.row
        return cell
    }
}

extension SavedViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        let previewController = UIViewController()
        let image = imageDatas[indexPath.row].image
        
        let imageView = UIImageView(image: image)
        previewController.view = imageView
        let width = collectionView.frame.size.width
        let height = (imageView.frame.size.height / imageView.frame.size.width) * width
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        previewController.preferredContentSize = imageView.frame.size
        
        
        let configuration = UIContextMenuConfiguration(identifier: "savedImage" as NSCopying) {
            previewController
        } actionProvider: { _ in
            let deleteAction = UIAction(title: "삭제하기", identifier: nil, discoverabilityTitle: nil) { action in
                print(action)
            }
            return UIMenu(title: "메뉴", options: .displayInline, children: [deleteAction])
        }
        
        return configuration
    }
}

extension SavedViewController: SaveCollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath: IndexPath
    ) -> CGFloat {
        let inset = collectionView.contentInset
        let insetSize = inset.left + inset.right
        let contentWidth = collectionView.frame.width
        guard let image = imageDatas[heightForPhotoAtIndexPath.row].image else {
            return 0
        }
        return (contentWidth - insetSize) * (image.size.height / image.size.width)
    }
    
    
}

extension SavedViewController: CellTopButtonDelegate {
    func CellTopButton(to starButton: UIButton) { }
    
    
}
