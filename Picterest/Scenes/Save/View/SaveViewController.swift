//
//  SaveViewController.swift
//  Picterest
//
//  Created by Kai Kim on 2022/07/28.
//

import UIKit

class SaveViewController: UIViewController {
  let viewModel: ImageConfigurable
  let layoutProvider = SceneLayout(scene: .save, cellPadding: 6)
  
  init(viewModel: ImageConfigurable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutProvider)
    collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.id)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchImage()
    setDataBinding()
  }


  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    setConstraints()
  }
}

private extension SaveViewController {
  
  func fetchImage() {
    viewModel.fetchImages()
  }
  
  func setDataBinding() {
    viewModel.imageList.bind({ list in
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
    })
  }
  
  func setConstraints() {
    view.addSubview(collectionView)
    if let layout = collectionView.collectionViewLayout as? SceneLayout {
      layout.delegate = self
    }
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  func didReceiveToogleLikeStatus(on cell: ImageCell) {
    cell.saveDidTap = {
      print($0.storedDirectory)
      //TODO: 
    }
  }
  
}

extension SaveViewController: UICollectionViewDataSource, SceneLayoutDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let count = viewModel.imageList.value.count
    return count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.id, for: indexPath) as? ImageCell,
          let model = viewModel[indexPath]
    else {
      return UICollectionViewCell()
    }
    cell.configure(model: model, indexPath: indexPath, sceneType: .save)
    didReceiveToogleLikeStatus(on: cell)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
    guard let model = viewModel[indexPath],
          let image = ImageManager.shared.getSavedImage(named: model.imageURL.lastPathComponent)
    else {return 0}
    let widthRatio = image.size.width / image.size.height
    return ((view.frame.width / CGFloat(layoutProvider.numberOfColumns)) - layoutProvider.cellPadding * 2) / widthRatio
  }

}
