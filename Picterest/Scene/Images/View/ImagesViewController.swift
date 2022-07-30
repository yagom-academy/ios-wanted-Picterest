//
//  ViewController.swift
//  Picterest
//

import UIKit

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    let viewModel = ImagesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setData()
    }
    
    private func setCollectionView() {
        let layout = PhotoCollectionViewLayout()
        layout.delegate = self
        self.photoCollectionView.collectionViewLayout = layout
        self.photoCollectionView.dataSource = self
        self.photoCollectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(deletImage(_:)), name: .cancleSavedImage, object: nil)
    }
    
    private func setData() {
        viewModel.viewPhotoList()
        viewModel.photoList.bind { [weak self] photoList in
            DispatchQueue.main.async {
                self?.photoCollectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    
    @objc func deletImage(_ notification: Notification) {
        let model = notification.object as! ImageInfo
        if let index = viewModel.photoList.value.firstIndex(where: {$0.id == model.id}) {
            viewModel.photoList.value[index].isSaved = false
            DispatchQueue.main.async {
                self.photoCollectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
}

//MARK: - PhotoCollectionViewLayout
extension ImagesViewController: PhotoCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, ratioForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        let model = viewModel[indexPath]
        let ratio = CGFloat(model.height) / CGFloat(model.width)
        return ratio
    }
}

//MARK: - UICollectionViewDataSource
extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        let model = viewModel[indexPath]
        
        cell.viewController = self
        cell.photoCountLabel.text = "\(indexPath.row)번째 사진"
        cell.setButtonImage(isSaved: model.isSaved)
        cell.cancleSaveImage = { [weak self] in
            self?.viewModel.photoList.value[indexPath.row].isSaved = false
            self?.viewModel.deleteImage(id: model.id)
        }
        cell.acceptSaveMemo = { [weak self] memo in
            self?.viewModel.photoList.value[indexPath.row].isSaved = true
            self?.viewModel.savedImage(image: cell.photoImageView.image ?? UIImage(), memo: memo, photoInfo: model)
        }
        
        viewModel.loadImage(url: model.urls.small) { result in
            print(model.urls.small)
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.photoImageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
        
        return cell
    }
}


//MARK: - UIScrollViewDelegate
extension ImagesViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > photoCollectionView.contentSize.height - scrollView.frame.size.height {
            viewModel.viewPhotoList()
        }
    }
}


