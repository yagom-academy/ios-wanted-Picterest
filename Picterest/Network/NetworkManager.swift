//
//  NetworkManager.swift
//  Picterest
//
//

import Foundation

class NetworkManager {
    func getPhotoList(){
        let session = URLSession(configuration: .default)
        var components = URLComponents(string: Constant.BASE_URL)
        let clientID = URLQueryItem(name: "client_id", value: PicterestKey.appKey)
        let count = URLQueryItem(name: "count", value: "15")
        components?.queryItems = [clientID, count]
        
        guard let url = components?.url else { return }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let result: [PhotoModel] = try JSONDecoder().decode([PhotoModel].self, from: data)
                print(result)
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}


