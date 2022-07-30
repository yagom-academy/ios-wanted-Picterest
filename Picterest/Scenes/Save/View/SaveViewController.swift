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
    resetData()
    fetchImage()
    setDataBinding()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    setConstraints()
    setGuesture()
  }
  
}

private extension SaveViewController {
  
  func resetData(){
    viewModel.resetList()
  }
  
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
    
  func setGuesture() {
    let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
    lpgr.minimumPressDuration = 0.5
    lpgr.delegate = self
    lpgr.delaysTouchesBegan = true
    self.collectionView.addGestureRecognizer(lpgr)
  }
  
  @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
    if gestureRecognizer.state == .began {
      let p = gestureRecognizer.location(in: self.collectionView)
      if let indexPath = self.collectionView.indexPathForItem(at: p) {
        guard let model = viewModel[indexPath] else {return}
        handleAlert(model)
      } else {
        print("couldn't find index path")
      }
    }
  }
  
  func handleAlert(_ model: ImageEntity) {
    guard let memo = model.memo else {return}
    _ = MemoAlert.makeAlertController(title: nil,
                                      message: "선택하신 메모 '\(memo)' 를 지우시겠습니까?",
                                      actions: .ok({ _ in
      self.viewModel.toogleLikeState(item: model) { error in
        if let error = error {
          print(error.localizedDescription)
        }
      }
    }), .cancel, from: self)
  }
  
}

extension SaveViewController: UICollectionViewDataSource, SceneLayoutDelegate, UIGestureRecognizerDelegate {
  
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
