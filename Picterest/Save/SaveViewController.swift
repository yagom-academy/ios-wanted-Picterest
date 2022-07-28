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
    var savePhotoList: [SavePhoto] = []
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        attribute()
        layout()
        bind(viewModel)
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
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        do {
            let savePhoto = try context.fetch(SavePhoto.fetchRequest()) as! [SavePhoto]
            savePhotoList = savePhoto
            saveTableView.reloadData()
        } catch {
            print(error.localizedDescription)
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
        cell.labelStackView.photoLabel.text = ""
        
        return cell
    }
}
