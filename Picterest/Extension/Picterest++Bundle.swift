//
//  Picterest++Bundle.swift
//  Picterest
//
//  Created by oyat on 2022/07/25.
//

import Foundation

extension Bundle {
    var clientIdKey: String {
        guard let file = self.path(forResource: "UnsplashInfo", ofType: "plist") else { return ""}
        guard let resource = NSDictionary(contentsOfFile: file) else { return ""}
        guard let key = resource["CLIENT_ID_KEY"] as? String else { fatalError("UnsplashInfo.plist에 CLIENT_ID_KEY설정을 해주세요.")}
        return key
    }
}
