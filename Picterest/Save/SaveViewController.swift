//
//  SaveViewController.swift
//  Picterest
//
//  Created by 백유정 on 2022/07/25.
//

import UIKit
import CoreData

class SaveViewController: UIViewController {

    private var saveTableView = UITableView()
    private var viewModel = SaveViewModel()
    private var savePhotoList: [SavePhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        attribute()
        layout()
        bind(viewModel)
        LongPress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchSavePhoto()
    }
}

extension SaveViewController {
    
    private func attribute() {
        saveTableView.register(SaveTableViewCell.self, forCellReuseIdentifier: SaveTableViewCell.identifier)
        saveTableView.delegate = self
        saveTableView.dataSource = self
    }
    
    private func layout() {
        [
            saveTableView
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            saveTableView.topAnchor.constraint(equalTo: view.topAnchor),
            saveTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            saveTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bind(_ viewModel: SaveViewModel) {
        self.viewModel = viewModel
    }
    
    private func fetchSavePhoto() {
        let savePhoto = CoreDataManager.shared.fetchSavePhoto()
        savePhotoList = savePhoto
        saveTableView.reloadData()
    }
    
    private func LongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        saveTableView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: saveTableView)
            if let indexPath = saveTableView.indexPathForRow(at: touchPoint) {
                
                let alert = UIAlertController(title: "사진 삭제", message: "사진을 삭제하시겠습니까?", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                let delete = UIAlertAction(title: "삭제", style: .default) { delete in
                    
                    let savePhotoData = self.savePhotoList[indexPath.row]
                    
                    self.viewModel.deleteSavePhoto(savePhotoData)
                    
                    self.savePhotoList.remove(at: indexPath.row)
                    self.saveTableView.reloadData()
                }
                
                alert.addAction(cancel)
                alert.addAction(delete)
                self.present(alert, animated: true)
            }
        }
    }
}

extension SaveViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savePhotoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = saveTableView.dequeueReusableCell(withIdentifier: SaveTableViewCell.identifier, for: indexPath) as? SaveTableViewCell else { return UITableViewCell() }
        
        cell.fetchData(savePhotoList[indexPath.row])
        cell.labelStackView.photoLabel.text = savePhotoList[indexPath.row].memo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width: CGFloat = (view.bounds.width - 4)
        return (width * savePhotoList[indexPath.row].ratio)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveTableView.frame = saveTableView.frame.inset(by: UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20))
    }
}
