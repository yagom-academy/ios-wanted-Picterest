//
//  Bundle + extension.swift
//  Picterest
//
//  Created by BH on 2022/07/25.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "PhotoInfo", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else { fatalError("PhotoInfo.plist에 API_KEY 설정을 해주세요.")}
        return key
    }
}
