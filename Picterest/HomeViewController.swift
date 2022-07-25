//
//  ViewController.swift
//  Picterest
//

import UIKit

class HomeViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let test = NetworkService()
    let endPoint = EndPoint(path: .showList, query: .imagesPerPage())
    let request = Requset(requestType: .get, body: nil, endPoint: endPoint)
    
    test.request(on: request.value) { result in
      switch result {
      case .success(let data):
        print(data)
        let decoder = Decoder<[ImageDTO]>()
        print(decoder.decode(data: data))
      case .failure(let error):
        print(error)
      }
    }
    
  }
  
  
}

