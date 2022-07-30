//
//  SavedViewController.swift
//  Picterest
//
//  Created by oyat on 2022/07/25.
//

import UIKit

class SavedViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel = SavedViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        // 줄 간의 거리 (단위는 포인트)
        flowLayout.minimumLineSpacing = 30
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SavedImageCell.self, forCellWithReuseIdentifier: SavedImageCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCell()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadCell() {
        viewModel.updateSaveData { [weak self] in
                   DispatchQueue.main.async {
                       self?.collectionView.reloadData()
                   }
               }
           }
}

extension SavedViewController {
    private func configureUI() {
        title = "Saved Images"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}


extension SavedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        return CGSize(width: width, height: 300)
    }
    
}

extension SavedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.saveDataCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedImageCell.reuseIdentifier, for: indexPath) as? SavedImageCell else { return SavedImageCell()
        }
        
        let saveData = viewModel.saveData(at: indexPath.row)
        cell.configure(data: saveData)
        
        return cell
    }
}


