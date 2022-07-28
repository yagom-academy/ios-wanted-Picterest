//
//  SavedViewController.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import UIKit
import Combine

class SavedViewController: UIViewController {
    private let reuseIdentifier = "SavedCell"
    private let viewModel = SavedViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetch()
    }
    
}

extension SavedViewController {
    private func bind() {
        viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.collectionView.reloadData()
            }
            .store(in: &cancellable)
    }
}


extension SavedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getImagesCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("saved index: \(indexPath.row)")

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SavedCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let imageData = viewModel.getImage(at: indexPath.row) else {
            print("get image data error")
            return UICollectionViewCell()
        }

        cell.view.imageView.loadImage(urlString: imageData.originalURL, imageID: imageData.id)
        cell.view.textLabel.text = imageData.memo
        cell.view.saveButton.tintColor = .yellow
        cell.view.saveButton.imageView?.image = UIImage(systemName: "star.fill")
        
        return cell
    }
}

extension SavedViewController: ImageCollectionViewCellDelegate {
    func alert(from cell: ImagesCollectionViewCell) {
        print("alert")
    }
    
}

extension SavedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        flow.scrollDirection = .vertical
        
        
        
//        let cellWidth: CGFloat = UIScreen.main.bounds.width - 50
        
        return CGSize(width: 500, height: 500)
    }
}
