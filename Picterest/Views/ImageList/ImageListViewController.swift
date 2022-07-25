//
//  ImageListViewController.swift
//  Picterest
//
//  Created by 신의연 on 2022/07/25.
//

import UIKit

class ImageListViewController: UIViewController {
    
    private let viewModel = ImageListViewModel()
    
    private var activity: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var picterestCollectionView: UICollectionView = {
        let layout = PicterestCollectionViewLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PicterestCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setLayout()
        addViewModelObserver()
        
    }
    
    private func setDelegate() {
        picterestCollectionView.delegate = self
        picterestCollectionView.dataSource = self
        if let layout = picterestCollectionView.collectionViewLayout as? PicterestCollectionViewLayout {
            layout.delegate = self
        }
    }
    
    private func setLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(activity)
        view.addSubview(picterestCollectionView)
        
        NSLayoutConstraint.activate([
            
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            picterestCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            picterestCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            picterestCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picterestCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func addViewModelObserver() {
        viewModel.loadingStarted = { [weak activity] in
            activity?.isHidden = false
            DispatchQueue.main.async {
                activity?.startAnimating()
            }
        }
        viewModel.loadingEnded = { [weak activity] in
            DispatchQueue.main.async {
                activity?.stopAnimating()
            }
            
        }
        viewModel.imageListUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.picterestCollectionView.reloadData()
            }
        }
        viewModel.list()
    }
    
}

extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = picterestCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PicterestCollectionViewCell
        let imageData = viewModel.image(at: indexPath.row)
        cell.fetchImageData(data: imageData, at: indexPath.row)
        return cell
    }
}

extension ImageListViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        // image view size 조절 클래스 필요
        //return photos[indexPath.item].image.size.height
        return 200
    }
}
