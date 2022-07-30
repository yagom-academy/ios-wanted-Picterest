//
//  PhotoSaveViewController.swift
//  Picterest
//
//

import UIKit

class PhotoSaveViewController: UIViewController {
    @IBOutlet weak var saveListCollectionView: UICollectionView!
    
    var coreData = [Picterest]()
    var deleteSavedData: (() -> Void)?
    var currentLongPressedCell: PhotoSaveCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didTapLongPressCell()
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreDataManager.shared.fetchCoreData(completion: { [weak self] coreData in
            self?.coreData = coreData
            self?.coreData = coreData.reversed()
        })
        self.saveListCollectionView.reloadData()
    }
}

//MARK: - Extension: CollectionView

extension PhotoSaveViewController {
    private func setCollectionView() {
        saveListCollectionView.dataSource = self
        saveListCollectionView.delegate = self
        saveListCollectionView?.contentInset = UIEdgeInsets(
            top: 10,
            left: 16,
            bottom: 10,
            right: 16
        )
        saveListCollectionView.register(
            UINib(
                nibName: PhotoSaveCollectionViewCell.identifier,
                bundle: nil
            ),
            forCellWithReuseIdentifier: PhotoSaveCollectionViewCell.identifier
        )
        let flowlayout = UICollectionViewFlowLayout()
        saveListCollectionView.collectionViewLayout = flowlayout
    }
}

extension PhotoSaveViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return coreData.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let saveCell = saveListCollectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoSaveCollectionViewCell.identifier,
            for: indexPath
        ) as? PhotoSaveCollectionViewCell else {
            return UICollectionViewCell()
        }
        saveCell.savedMemo.text = coreData[indexPath.row].memo
        saveCell.fetchDataFromCollectionView(data: coreData[indexPath.row].url ?? "")
        return saveCell
    }
}

extension PhotoSaveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = UIScreen.main.bounds.width - 42
        let height =  width * (coreData[indexPath.row].height / coreData[indexPath.row].width)
        return CGSize(width: width, height: height)
    }
}

//MARK: - Extension: Long Pressed

extension PhotoSaveViewController: UIGestureRecognizerDelegate {
    private func didTapLongPressCell() {
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(didTapDelete)
        )
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        longPressGesture.delaysTouchesBegan = true
        saveListCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func didTapDelete(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let point = gestureRecognizer.location(in: self.saveListCollectionView)
            guard let indexPath = self.saveListCollectionView?.indexPathForItem(
                at: point
            ) else { return }
            let deletAlert = UIAlertController.presentSaveAndDeleteAlert(
                title: "사진 삭제",
                message: "사진을 삭제 하시겠습니까?",
                isTextField: false,
                isLongPress: true) {  [weak self] _ in
                    guard let id = self?.coreData[indexPath.row].id else { return }
                    ImageFileManager.shared.deleteImageFromLocal(named: id + ".png")
                    CoreDataManager.shared.deleteCoreData(ID: id)
                    self?.coreData.remove(at: indexPath.item)
                    self?.saveListCollectionView.deleteItems(at: [indexPath])
                }
            self.present(deletAlert, animated: true)
        }
    }
}

