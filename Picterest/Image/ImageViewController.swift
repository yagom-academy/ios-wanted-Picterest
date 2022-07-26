//
//  ImageViewController.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit

protocol CustomLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class ImageViewController: UIViewController {
    
    private var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    private var photoRandomList: [Photo] = []
    private var viewModel = ImageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        attribute()
        layout()
        bind(viewModel)
        viewModel.getRandomPhoto { [weak self] result in
            guard let self = self  else { return }
            switch result {
            case .success(let photos):
                self.photoRandomList = photos
                DispatchQueue.main.async {
                    self.imageCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ImageViewController {
    
    private func attribute() {
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        let customLayout = ImageColletionViewCustomLayout()
        customLayout.delegate = self
        imageCollectionView.collectionViewLayout = customLayout
    }
    
    private func layout() {
        [
            imageCollectionView
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bind(_ viewModel: ImageViewModel) {
        self.viewModel = viewModel
    }
}

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(photoRandomList.count)
        return photoRandomList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.fetchData(photoRandomList[indexPath.row], indexPath)
        return cell
    }
}

extension ImageViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let width: CGFloat = (view.bounds.width - 4) / 2
        let ratio: Double = photoRandomList[indexPath.row].height / photoRandomList[indexPath.row].width
        
        return CGFloat(width * ratio)
    }
}
