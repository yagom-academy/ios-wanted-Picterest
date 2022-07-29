//
//  SavedViewController.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/25.
//

import UIKit
import CoreData
import Combine

class SavedViewController: UIViewController {
    let savedViewModel: SavedViewModel
    private var subscription = Set<AnyCancellable>()
    private lazy var titleView = SaveCollectionTitleView()
    
    private lazy var collectionView: UICollectionView = {
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
    
    init(savedViewModel: SavedViewModel) {
        self.savedViewModel = savedViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        savedViewModel.fetchData()
        super.viewWillAppear(animated)
        bindSavedImage()
        bindReloadImage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        resetCollectionView()
        super.viewDidDisappear(animated)
    }
}

// MARK: - CollectionView DataSource
extension SavedViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return savedViewModel.savedImages.count
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
        let data = savedViewModel.savedImages[indexPath.row]
        if let image = data.image {
            cell.imageView.image = image.resizeImageTo(newWidth: cell.bounds.width)
        }
        configureTopButton(cell: cell, memo: data.memoDescription)
        return cell
    }
}

// MARK: - Collection View Delegate
extension SavedViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let previewController = makePreviewController(indexPath.row)
        let configuration = UIContextMenuConfiguration(identifier: "savedImage" as NSCopying) {
            previewController
        } actionProvider: { _ in
            let deleteAction = UIAction(
                title: "삭제하기",
                image: UIImage(systemName: "trash.fill"),
                identifier: nil,
                attributes: .destructive
            ) { action in
                self.presentAlertView(indexPath.row)
            }
            return UIMenu(title: "메뉴", options: .displayInline, children: [deleteAction])
        }
        
        return configuration
    }
    
    func makePreviewController(_ index: Int) -> UIViewController {
        let previewController = UIViewController()
        let image = savedViewModel.savedImages[index].image
        let preview = UIImageView(image: image)
        previewController.view = preview
        let width = collectionView.frame.size.width
        let height = (preview.frame.size.height / preview.frame.size.width) * width
        preview.frame = CGRect(x: 0, y: 0, width: width, height: height)
        previewController.preferredContentSize = preview.frame.size
        return previewController
    }
    
    private func presentAlertView(_ index: Int) {
        let alert = AlertViewController(
            titleText: "삭제 안내",
            messageText: "정말 삭제하시겠습니다?\n삭제 후에는 복원할 수 없습니다.",
            alertType: .confirmAndCancel
        ) { [weak self] _ in
            self?.savedViewModel.deleteData(index)
        }
        
        self.present(alert, animated: false)
    }
    
}

// MARK: - Save Collection View Delegate
extension SavedViewController: SaveCollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath: IndexPath
    ) -> CGFloat {
        let index = heightForPhotoAtIndexPath.row
        let inset = collectionView.contentInset
        let insetSize = inset.left + inset.right
        let contentWidth = collectionView.frame.width
        guard let image = savedViewModel.savedImages[index].image else {
            return 0
        }
        return (contentWidth - insetSize) * (image.size.height / image.size.width)
    }
    
    
}

// MARK: - Data Method
extension SavedViewController {
    func bindSavedImage() {
        savedViewModel.$savedImages
            .sink { [weak self] _ in
                let collectionLayout = self?.collectionView.collectionViewLayout
                if let layout = collectionLayout as? SavedCollectionViewLayout {
                    layout.resetLayout()
                }
                self?.collectionView.reloadData()
            }
            .store(in: &subscription)
    }
    
    func bindReloadImage() {
        savedViewModel.$isReLoadView
            .sink { [weak self] isReLoad in
                if isReLoad {
                    self?.resetCollectionView()
                }
            }
            .store(in: &subscription)
    }
}

// MARK: - UI Configure

private extension SavedViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .clear
        [titleView,collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            
            titleView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            titleView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 50),
            titleView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            

        ])
    }
    
    func configureTopButton(cell: SavedCollectionCustomCell, memo: String) {
        cell.topView.starButton.isSelected = true
        cell.topView.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        cell.topView.starButton.isEnabled = false
        cell.topView.indexLabel.text = memo
    }
    
    func resetCollectionView() {
        savedViewModel.resetData()
        savedViewModel.fetchData()
        savedViewModel.isReLoadView = false
    }
}
