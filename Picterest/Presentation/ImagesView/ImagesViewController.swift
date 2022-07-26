//
//  ViewController.swift
//  Picterest
//

import UIKit

class ImagesViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = ImagesViewModel()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureUI()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods
extension ImagesViewController {
    
    private func fetchData() {
        viewModel.fetchData { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func configureUI() {
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
    }
}

// MARK: - CollectionView DataSoucrce
extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else { return  ImageCell() }
        
        cell.configure(data: viewModel.imageData(indexPath: indexPath))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imagedDataCount
    }
}

