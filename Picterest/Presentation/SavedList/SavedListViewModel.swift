//
//  SavedListViewModel.swift
//  Picterest
//
//  Created by yc on 2022/07/27.
//

import Foundation

class SavedListViewModel {
    
    var savedListTableViewCellViewModel: SavedListTableViewCellViewModel? {
        willSet {
            
        }
    }
    
    func makeSavedListTableViewCellViewModel(
        savedPhoto: CoreSavedPhoto
    ) -> SavedListTableViewCellViewModel {
        let viewModel = SavedListTableViewCellViewModel(savedPhoto: savedPhoto)
        savedListTableViewCellViewModel = viewModel
        return viewModel
    }
}
