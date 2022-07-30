//
//  ViewController.swift
//  Picterest
//

import UIKit

final class ViewController: UIViewController {

    private let photoAPI = PhotoAPI()
    private var photoURLs: [PhotoURL] = []
    private var photos: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchPhotoURL()
    }

}

extension ViewController {
    
    private func fetchPhotoURL() {
        photoAPI.fetchImageURL { [weak self] result in
            switch result {
            case .success(let responses):
                responses.forEach {
                    self?.fetchPhoto(from: $0.photoURL.raw)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchPhoto(from urlString: String) {
        photoAPI.fetchImage(from: urlString) { [weak self] result in
            switch result {
            case .success(let photo):
                self?.photos.append(photo)
            case .failure(let error):
                print(error)
            }
        }
    }
}
