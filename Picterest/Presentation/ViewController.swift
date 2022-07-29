//
//  ViewController.swift
//  Picterest
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var cancellableSet = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nw = DefaultNetworkService()
        guard let re = try? nw.getPhotos(howMuch: 2) else {
            print("실팬디?")
            return
        }
        
        re.sink { completion in
            switch completion {
            case.failure(let error):
                print(error)
            case.finished:
                print("finished")
            }
        } receiveValue: { photos in
            print(photos.count)
            photos.forEach({
                print($0.id)
            })
        }.store(in: &cancellableSet)

    }


}

