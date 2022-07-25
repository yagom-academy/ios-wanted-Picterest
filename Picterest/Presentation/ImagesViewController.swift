//
//  ViewController.swift
//  Picterest
//

import UIKit

class ImagesViewController: UIViewController {
    
    // MARK: - Properties
    var imageDatas: [ImageInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    
    private func fetchData() {
        NetworkManager.shard.fetchImages { result in
            switch result {
            case .success(let result):
                self.imageDatas = result
                print(self.imageDatas.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

