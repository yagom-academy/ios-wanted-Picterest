//
//  SavedImageListViewController.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class SavedImageListViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    private let viewModel = SavedImageListViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        attribute()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadCell() {
        viewModel.updateData { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

//MARK: - attribute, layout 메서드
extension SavedImageListViewController {
    
    private func attribute() {
        view.backgroundColor = Style.Color.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SavedImageListCell.self, forCellWithReuseIdentifier: SavedImageListCell.reuseIdentifier)
    }
    
    private func layout() {
        [collectionView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

//MARK: - CollectionView DataSource 메서드
extension SavedImageListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedImageListCell.reuseIdentifier, for: indexPath) as? SavedImageListCell else { return UICollectionViewCell() }
        cell.configure(data: viewModel.cellData(indexPath.row))
        cell.delegate = self
        return cell
    }
}

//MARK: - CollectionView FlowLayout Delegate 메서드
extension SavedImageListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.cellSize(indexPath.row)
    }
}

//MARK: - SavedImageListCell Delegate 메서드
extension SavedImageListViewController: SavedImageListCellDelegate {
    func didLongTappedCell(id: UUID) {
        let alert = CheckRemoveAlertViewController(id: id)
        alert.modalPresentationStyle = .overFullScreen
        alert.delegate = self
        present(alert, animated: false)
    }
}

//MARK: - CheckRemoveAlertViewController Delegate 메서드
extension SavedImageListViewController: CheckRemoveAlertViewDelegate {
    func tappedRemoveButton(id: UUID) {
        viewModel.removeCell(at: id) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}
