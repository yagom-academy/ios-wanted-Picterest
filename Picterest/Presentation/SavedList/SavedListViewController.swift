//
//  SavedListViewController.swift
//  Picterest
//
//  Created by yc on 2022/07/25.
//

import UIKit

class SavedListViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var savedListTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(
            SavedListTableViewCell.self,
            forCellReuseIdentifier: SavedListTableViewCell.identifier
        )
        return tableView
    }()
    
    // MARK: - Properties
    private var savedList: [CoreSavedPhoto] = CoreDataManager.shared.fetch()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
}

// MARK: - UITableViewDataSource
extension SavedListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SavedListTableViewCell.identifier,
            for: indexPath
        ) as? SavedListTableViewCell else { return UITableViewCell() }
        cell.setupView(path: savedList[indexPath.row].path)
        return cell
    }
}

// MARK: - UI Methods
private extension SavedListViewController {
    func configUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(savedListTableView)
        savedListTableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            savedListTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            savedListTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            savedListTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            savedListTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
