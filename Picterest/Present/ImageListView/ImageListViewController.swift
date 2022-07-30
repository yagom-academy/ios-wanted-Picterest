//
//  ImageListViewController.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import UIKit

final class ImageListViewController: UIViewController {
    
    private enum Define {
        static let numberOfColumns: Int = 2
        static let numberOfSections: Int = 1
    }
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CustomCollectionViewLayout())
        collectionView.backgroundColor = Style.Color.collectionViewBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let viewModel = ImageListViewModel(networkManager: NetworkManager.shared)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        attribute()
        layout()
        initCellData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateCellState { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

//MARK: - CustomCollectionViewLayoutDelegate
extension ImageListViewController: CustomCollectionViewLayoutDelegate {
    func collectionView(heightMultiplierForPhotoAtRow row: Int) -> CGFloat {
        return viewModel.cellHeightMultiplier(row)
    }
    
    func collectionView(heightFooterAtIndexPath indexPath: IndexPath) -> CGFloat {
        return FooterStyle.Math.height
    }
    
    func collectionView(numberOfColumnsInSection section: Int) -> Int {
        return Define.numberOfColumns
    }
}

//MARK: - CollectionViewDa
extension ImageListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageListCell.reuseIdentifier, for: indexPath) as? ImageListCell else { return UICollectionViewCell() }
        cell.configure(row: indexPath.row, data: viewModel.cellData(indexPath.row))
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
        return Define.numberOfSections
    }
}

// MARK: - 셀데이터를 새로고침시키는 메서드(+콜렉션뷰를 당겼을 때)
extension ImageListViewController {
    private func setRefresh() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(initCellData), for: .valueChanged)
    }

    @objc private func initCellData() {
        viewModel.initData { [weak self] result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self?.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
}

//MARK: - Cell Delegate 이벤트
extension ImageListViewController: ImageListCellDelegate {
    func tappedSaveButton(_ row: Int) {
        let alert = SaveImageAlertViewController(row: row)
        alert.delegate = self
        alert.modalPresentationStyle = .overFullScreen
        present(alert, animated: false)
    }
}

//MARK: - Footer Delegate 이벤트
extension ImageListViewController: AddCellButtonFooterViewDelegate {
    func tappedAddCellButton() {
        viewModel.loadExtraData { [weak self] result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
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
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.description)
            }
        }
    }
}

//MARK: - attribute, layout 메서드
extension ImageListViewController {
    private func attribute() {
        setRefresh()
        view.backgroundColor = Style.Color.background
        
        if let layout = collectionView.collectionViewLayout as? CustomCollectionViewLayout {
          layout.delegate = self
        }
        collectionView.dataSource = self
        collectionView.register(ImageListCell.self, forCellWithReuseIdentifier: ImageListCell.reuseIdentifier)
        collectionView.register(AddCellButtonFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: AddCellButtonFooterView.reuseIdentifier)
    }
    
    private func layout() {
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
