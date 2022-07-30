//
//  KeyChainService.swift
//  Picterest
//
//  Created by 이경민 on 2022/07/25.
//

import Foundation

protocol KeyChainManagable {
    var key: String { get }
}

class KeyChainService: KeyChainManagable {
    static var shared = KeyChainService()
    
    private let account = "ApiKey"
    private let service = "com.mini.picterest"
    var key: String = ""

    init() {
        if !self.readItem() {
            self.key = Bundle().accessKey
            
            let _ = addItem()
        }
        
        if key != Bundle().accessKey {
            let isUpdate = updateKeyValue()
            if isUpdate {
                let _ = self.readItem()
            }
        }
    }
    
    
    func readItem() -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        
        let result = SecItemCopyMatching(query as CFDictionary, &item)
        
        if result == errSecSuccess {
            if let item = item as? [String: Any],
               let data = item[kSecValueData as String] as? Data,
               let apiKey = String(data: data, encoding: .utf8) {
                print("Read Success")
                self.key = apiKey
            }
        }
        
        return result == errSecSuccess
    }
    
    func addItem() -> Bool {
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecValueData: key.data(using: .utf8) as Any
        ]
        
        let result: Bool = {
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status == errSecSuccess {
                return true
            } else {
                return false
            }
        }()
        
        return result
    }
    
    func updateKeyValue() -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecValueData: key.data(using: .utf8) as Any
        ]
        let attribute: [CFString: Any] = [
            kSecAttrAccount: account,
            kSecValueData: Bundle().accessKey.data(using: .utf8) as Any
        ]
        let result = SecItemUpdate(query as CFDictionary, attribute as CFDictionary) == errSecSuccess
        return result
    }
}
