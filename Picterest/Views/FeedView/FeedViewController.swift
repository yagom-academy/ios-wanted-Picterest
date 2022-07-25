//
//  FeedViewController.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/25.
//

import UIKit
import Combine

class FeedViewController: UIViewController {
    private var cancellable = Set<AnyCancellable>()
    let viewModel: FeedViewModel
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets.zero
        let collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FeedCellView.self, forCellWithReuseIdentifier: FeedCellView.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = FeedViewModel(key: "")
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        configView()
        view.backgroundColor = .lightGray
        
        bindImage()
    }
}



// MARK: - CollectionView DataSource
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("collection view number of items in section \(viewModel.photos.count)")
        return viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCellView.identifier, for: indexPath) as? FeedCellView else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
}

// MARK: - CollectionView Delegate
extension FeedViewController: UICollectionViewDelegate {
    
}

// MARK: - Binding Methods
private extension FeedViewController {
    func bindImage() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellable)
    }
}

// MARK: - UI Configure Methods
private extension FeedViewController {
    func setUpNavBar() {
        navigationItem.title = "피드"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    func configView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
