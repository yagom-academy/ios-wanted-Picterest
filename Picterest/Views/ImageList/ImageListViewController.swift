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
        indicator.style = .large
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
        setViewModelObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.listUpdate()
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
    
    private func setViewModelObserver() {
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
        return viewModel.imageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = picterestCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PicterestCollectionViewCell
        cell.delegate = self
        let imageData = viewModel.image(at: indexPath.row)
        cell.fetchImageData(data: imageData, at: indexPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height - 50 {
            viewModel.next()
        }
    }
    
}

extension ImageListViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return viewModel.imageSize(at: indexPath.row)
    }
}

extension ImageListViewController: PicterestPhotoSavable {
    func picterestCollectoinViewCell(isSelected: Bool, imageInfo: SavableImageData, imageData: UIImage, idx: IndexPath) {
        
        if isSelected {
            setImageSaveAlert(imageInfo: imageInfo, imageData: imageData, indexPath: idx)
        } else {
            setImageDeleteAlert(imageInfo: imageInfo, indexPath: idx)
        }
    }
    
    func setImageSaveAlert(imageInfo: SavableImageData, imageData: UIImage, indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "이미지 메모", message: nil, preferredStyle: .alert)
        alert.addTextField()
        let saveAction = UIAlertAction(title: "저장", style: .default) { [self, weak alert] (_) in
            let memo = alert?.textFields![0].text ?? ""
            viewModel.savePicuture(image: imageData, memo: memo, at: indexPath.item)
        }
        
        alert.addAction(saveAction)
        
        self.present(alert, animated: true)
    }
    
    func setImageDeleteAlert(imageInfo: SavableImageData, indexPath: IndexPath) {
        let alert = UIAlertController(title: "삭제 되었습니다.", message: nil, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "확인", style: .default) { [self] (_) in
            viewModel.deletePicture(indexPath: indexPath)
        }
        alert.addAction(deleteAction)
        self.present(alert, animated: true)
    }
}

