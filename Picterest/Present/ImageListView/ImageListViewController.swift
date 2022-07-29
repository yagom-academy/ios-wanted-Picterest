//
//  ImageListViewController.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class ImageListViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CustomCollectionViewLayout())
    private let viewModel = ImageListViewModel(networkManager: NetworkManager.shared)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        attribute()
        layout()
        loadCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateCellState { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func loadCell() {
        viewModel.loadData { [weak self] result in
            switch result {
            case .success():
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - CustomCollectionViewLayoutDelegate
extension ImageListViewController: CustomCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightMultiplierForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return viewModel.cellHeightMultiplier(indexPath)
    }
    
    func collectionView(heightFooterAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfColumnsInSection section: Int) -> Int {
        return 2
    }
}

//MARK: - CollectionViewDa
extension ImageListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageListCell.reuseIdentifier, for: indexPath) as? ImageListCell else { return UICollectionViewCell() }
        cell.configure(indexPath: indexPath, data: viewModel.cellData(indexPath))
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalCellCount
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: AddCellButtonFooterView.reuseIdentifier, for: indexPath) as? AddCellButtonFooterView else { return UICollectionReusableView() }
        footer.delegate = self
        return footer
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

//MARK: - Cell Delegate 이벤트
extension ImageListViewController: ImageListCellDelegate {
    func tappedSaveButton(_ indexPath: IndexPath) {
        let alert = SaveImageAlertViewController(row: indexPath.row)
        alert.delegate = self
        alert.modalPresentationStyle = .overFullScreen
        present(alert, animated: false)
    }
}

//MARK: - Footer Delegate 이벤트
extension ImageListViewController: AddCellButtonFooterViewDelegate {
    func tappedAddCellButton() {
        viewModel.loadData { [weak self] result in
            switch result {
            case .success():
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - SaveImageAlertView Delegate 이벤트
extension ImageListViewController: SaveImageAlertViewDelegate {
    func tappedSavedButton(row: Int, message: String) {
        viewModel.saveImage(row: row, message: message) { [weak self] result in
            switch result {
            case .success():
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

//MARK: - attribute, layout 메서드
extension ImageListViewController {
    private func attribute() {
        //temp
        view.backgroundColor = .yellow
        
        if let layout = collectionView.collectionViewLayout as? CustomCollectionViewLayout {
          layout.delegate = self
        }
        
        collectionView.backgroundColor = .purple
        collectionView.dataSource = self
        collectionView.register(ImageListCell.self, forCellWithReuseIdentifier: ImageListCell.reuseIdentifier)
        collectionView.register(AddCellButtonFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: AddCellButtonFooterView.reuseIdentifier)
    }
    
    private func layout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
