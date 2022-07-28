//
//  TabBarViewModel.swift
//  Picterest
//
//  Created by yc on 2022/07/28.
//

import Foundation

class TabBarViewModel {
    let photoListViewModel = PhotoListViewModel()
    let savedListViewModel = SavedListViewModel()
    
    init() {
        photoListViewModel.updateSavedList.bind { [weak self] in
            self?.savedListViewModel.updateSavedList.value = $0
        }
        savedListViewModel.updateStarButton.bind { [weak self] in
            self?.photoListViewModel.updateStarButton.value = $0
        }
    }
}
