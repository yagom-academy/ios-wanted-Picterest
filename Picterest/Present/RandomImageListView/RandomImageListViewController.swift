//
//  ImageListViewController.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class RandomImageListViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CustomCollectionViewLayout())
    private let viewModel = RandomImageListViewModel(networkManager: NetworkManager.shared)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
        loadCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
extension RandomImageListViewController: CustomCollectionViewLayoutDelegate {
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
extension RandomImageListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomImageListCell.reuseIdentifier, for: indexPath) as? RandomImageListCell else { return UICollectionViewCell() }
        cell.configure(indexPath: indexPath, data: viewModel.cellData(indexPath))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellTotalCount
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

extension RandomImageListViewController: AddCellButtonFooterViewDelegate {
    func tappedAddCellButton() {
        viewModel.loadData { [weak self] result in
            switch result {
            case .success():
                print("성공")
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}


//MARK: - attribute, layout 메서드
extension RandomImageListViewController {
    private func attribute() {
        //temp
        view.backgroundColor = .yellow
        
        if let layout = collectionView.collectionViewLayout as? CustomCollectionViewLayout {
          layout.delegate = self
        }
        
        collectionView.backgroundColor = .purple
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.register(RandomImageListCell.self, forCellWithReuseIdentifier: RandomImageListCell.reuseIdentifier)
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

//extension RandomImageListViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: 100, height: 100)
//    }
//}
