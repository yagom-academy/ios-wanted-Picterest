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
        collectionView.backgroundColor = .blue
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

extension ImagesViewController {
    
    private func fetchData() {
        NetworkManager.shard.fetchImages { result in
            switch result {
            case .success(let result):
                self.imageDatas = result
                print(self.imageDatas.count)
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
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ])
    }
}

// MARK: - CollectionView DataSoucrce
extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageDatas.count
    }
}

