//
//  NetworkManager.swift
//  Picterest
//
//  Created by hayeon on 2022/07/26.
//

import Foundation

final class NetworkManager {
    
    func fetchData(url: URL, completion: @escaping ([ImageInformation]) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                  let safeData = data, error == nil else {
                    return
            }

            DispatchQueue.main.async() {
                do {
                    let decodedData = try JSONDecoder().decode([ImageInformation].self, from: safeData)
                    completion(decodedData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
}
