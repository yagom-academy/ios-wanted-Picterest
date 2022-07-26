//
//  ViewController.swift
//  Picterest
//

import UIKit

class HomeViewController: UIViewController {
  
  let viewModel = HomeViewModel()

  private var collectionView: UICollectionView = {
    let layoutProvider = HomeSceneLayout()
//    let layout = FlowLayoutManager.makeCompositionalLayout(layoutProvider)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutProvider)
    collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.id)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setConstraints()
    fetchImage()
    setDataBinding()
  }

  
}

private extension HomeViewController {
  
  
  func fetchImage() {
    viewModel.fetchImages()
  }
  
  func setDataBinding() {
    collectionView.dataSource = self
    viewModel.imageList.bind({ _ in
      DispatchQueue.main.async {
        self.collectionView.reloadData()
      }
    })
  }
  
  func setConstraints() {
    view.addSubview(collectionView)
    if let layout = collectionView.collectionViewLayout as? HomeSceneLayout {
      layout.delegate = self
    }
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
}

extension HomeViewController: UICollectionViewDataSource, HomeSceneLayoutDelegate {

  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.imageList.value.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.id, for: indexPath) as? ImageCell,
          let model = viewModel[indexPath]
    else {
      return UICollectionViewCell()
    }
    cell.configure(model: model)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
    guard let image = viewModel[indexPath] else {return 180}
    let widthRatio = image.width / image.height
    return view.frame.width / widthRatio
  }
  
}
