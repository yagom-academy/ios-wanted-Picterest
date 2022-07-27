//
//  ViewController.swift
//  Picterest
//

import UIKit

class PhotoListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var photoListAPIProvider: PhotoListAPIProviderType?
    
    // MARK: - LifeCycle
    
    static func instantiate(
        with photoListAPIProvider: PhotoListAPIProviderType
    ) -> PhotoListViewController {
        let viewController = PhotoListViewController()
        viewController.photoListAPIProvider = photoListAPIProvider
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        fetchPhotos()
    }
    
}

// MARK: - Extensions

extension PhotoListViewController {
    
    private func fetchPhotos() {
        photoListAPIProvider?.fetchPhotoList(completion: { result in
            switch result {
            case .success(let photos):
                dump(photos)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
