//
//  ViewController.swift
//  Picterest
//

import UIKit

class HomeViewController: UIViewController {
  
  let viewModel = HomeViewModel()
  let layoutProvider = SceneLayout(scene: .home, cellPadding: 6)
  private var isLoading = false
  var loadingView: Footer?
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutProvider)
    collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.id)
    collectionView.register(Footer.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Footer.id)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
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
    let group = DispatchGroup()
    viewModel.imageList.bind({ list in
      if list.count > 0 {
        group.enter()
        DispatchQueue.main.async {
          self.collectionView.insertItems(at: [IndexPath(item: list.count - 1, section: 0)])
          group.leave()
        }
      }
      group.wait()
    })
  }
  
  func setConstraints() {
    view.addSubview(collectionView)
    if let layout = collectionView.collectionViewLayout as? SceneLayout {
      layout.delegate = self
    }
    collectionView.delegate = self
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
}

extension HomeViewController: UICollectionViewDataSource, SceneLayoutDelegate, UICollectionViewDelegate {
  
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
    cell.configure(model: model)
    return cell
  }
    
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
    guard let image = viewModel[indexPath] else {return 0}
    let widthRatio = image.width / image.height
    return ((view.frame.width / CGFloat(layoutProvider.numberOfColumns)) - layoutProvider.cellPadding * 2) / widthRatio
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentOffsetY = scrollView.contentOffset.y
    if contentOffsetY >= (scrollView.contentSize.height - scrollView.bounds.height) - 20 {
      guard !self.isLoading else { return }
      self.isLoading = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.fetchImage()
        self.isLoading = false
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Footer.id, for: indexPath) as? Footer else {
        return UICollectionReusableView()
    }
    loadingView = footer
    loadingView?.activityIndicator.startAnimating()
    return footer
  }
  
}
