//
//  ViewController.swift
//  Picterest
//

import UIKit

class ImagesViewController: UIViewController {
    
    // MARK: - Properties
    private var imageDatas: [ImageInfo] = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureUI()
    }
}

// MARK: - Methods
extension ImagesViewController {
    
    private func fetchData() {
        NetworkManager.shard.fetchImages { result in
            switch result {
            case .success(let result):
                self.imageDatas = result
            case .failure(let error):
                print(error.localizedDescription)
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else { return  UICollectionViewCell() }
        
        cell.configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("갯수", imageDatas.count)
        return 15
        
    }
}

