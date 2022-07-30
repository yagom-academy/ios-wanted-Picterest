//
//  FeedViewController.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/25.
//

import UIKit
import Combine

class FeedViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: FeedViewModelAble
    private var subscription = Set<AnyCancellable>()
    
    // MARK: - View Properties
    lazy var collectionView: UICollectionView = {
        let layout = FeedCollectionLayout()
        layout.delegate = self
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.register(
            FeedCollectionCustomCell.self,
            forCellWithReuseIdentifier: String.FeedCellIdentifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionView
    }()
    
    // MARK: - Init Methods
    init(feedViewModel: FeedViewModelAble) {
        self.viewModel = feedViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = FeedViewModel()
        super.init(coder: coder)
    }
    
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        configView()
        bindImageData()
    }
}

// MARK: - ScrollView Delegate
extension FeedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > collectionView.contentSize.height - 20 - scrollView.frame.size.height {
            guard !viewModel.isLoading else {
                return
            }
            viewModel.loadImageData()
        }
    }
}

// MARK: - Cell Top Button Delegate
extension FeedViewController: CellTopButtonDelegate {
    func CellTopButton(to didTapStarButton: UIButton) {
        if didTapStarButton.isSelected {
            presentErrorAlert()
        } else {
            presentWriteAlert(sender: didTapStarButton)
        }
    }
}

// MARK: - CollectionView Delegate
extension FeedViewController: UICollectionViewDelegate {}

// MARK: - CollectionView DataSource
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.imageDatas.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String.FeedCellIdentifier,
            for: indexPath
        ) as? FeedCollectionCustomCell else {
            return UICollectionViewCell()
        }
        let imageData = viewModel.imageDatas[indexPath.row]
        
        let imageSizeQuery = [
            "w": cell.frame.size.width.description,
            "h": cell.frame.size.height.description
        ]
        let endPoint = EndPoint(baseURL: imageData.urls.regular, query: imageSizeQuery)
        let imageLoader = ImageLoader(endPoint: endPoint)
        cell.imageLoader = imageLoader
        cell.setUpTask()
        cell.topButtonView.delegate = self
        cell.topButtonView.starButton.tag = indexPath.row
        
        let fetchIDs = viewModel.coreImage().compactMap { $0.id }
        
        if fetchIDs.contains(imageData.id) {
            cell.topButtonView.starButton.isSelected = true
            cell.topButtonView.starButton.setImage(UIImage.starFillImage, for: .normal)
        } else {
            cell.topButtonView.starButton.isSelected = false
            cell.topButtonView.starButton.setImage(UIImage.starImage, for: .normal)
        }
        
        cell.topButtonView.indexLabel.text = indexPath.row.description + "번째 사진입니다."
        return cell
    }
}

// MARK: - FeedCollectionLayout Delegate
extension FeedViewController: FeedCollectionLayoutDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        heightRateForPhotoAtIndexPath indexPath: IndexPath
    ) -> CGFloat {
        let item = viewModel.imageDatas[indexPath.item]
        return item.ratio
    }
}

// MARK: - Binding Methods
private extension FeedViewController {
    func bindImageData() {
        viewModel.imageDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                self?.collectionView.reloadData()
                self?.collectionView.collectionViewLayout.invalidateLayout()
            }
            .store(in: &subscription)
    }
}

// MARK: - UI Configure Methods
private extension FeedViewController {
    
    func presentErrorAlert() {
        let alertType: AlertType = .confirm
        let alertController = AlertViewController(
            titleText: alertType.alertTitle,
            messageText: alertType.alertMessage
        ) { _ in }
        present(alertController, animated: false)
    }
    
    func presentWriteAlert(sender: UIButton) {
        
        let alertType: AlertType = .confirmTextField
        let alertController = AlertViewController(
            titleText: alertType.alertTitle,
            messageText: alertType.alertMessage,
            alertType: alertType
        ) { [weak self] inputValue in
            self?.confirmAction(sender: sender, inputValue: inputValue ?? "")
        }
        self.present(alertController, animated: false)
    }
    
    func confirmAction(sender: UIButton, inputValue: String) {
        sender.isSelected = true
        sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        let width = self.collectionView.frame.size.width.description
        
        viewModel.saveImageInFile(index: sender.tag, width: width, inputValue: inputValue)
    }
    
    func setUpNavBar() {
        navigationItem.title = "피드"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    func configView() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
