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
    private var viewModel = ImageViewModel()
    private var photoList: [Photo] = []
    private var startPage = 0
    private var totalPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        attribute()
        layout()
        bind(viewModel)
        fetchPhoto()
    }
}

extension ImageViewController {
    
    private func attribute() {
        imageCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.prefetchDataSource = self
        
        
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
    
    private func fetchPhoto() {
        viewModel.getRandomPhoto(startPage) { [weak self] result in
            guard let self = self  else { return }
            switch result {
            case .success(let photos):
                for photo in photos {
                    self.photoList.append(photo)
                }
                DispatchQueue.main.async {
                    self.imageCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        cell.fetchData(photoList[indexPath.row], indexPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        <#code#>
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        if let cv = scrollView as? UICollectionView {
//            let layout = ImageColletionViewCustomLayout()
//            let cellHeight = layout.itemSize.height + layout.minimumLineSpacing
//
//            var offset = targetContentOffset.pointee
//            let idx = round((offset.x + cv.contentInset.top) + cellHeight)
//
//            offset = CGPoint(x: 0, y: CGFloat(idx) * cellHeight)
//        }
    }
}

extension ImageViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let width: CGFloat = (view.bounds.width - 4) / 2
        let ratio: Double = photoList[indexPath.row].height / photoList[indexPath.row].width
        
        return CGFloat(width * ratio)
    }
}

extension ImageViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if photoList.count - 1 == indexPath.row {
                startPage += 1
                fetchPhoto()
            }
        }
    }
}
