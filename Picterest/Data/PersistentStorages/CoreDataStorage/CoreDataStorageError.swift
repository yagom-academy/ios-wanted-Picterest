//
//  CoreDataStorageError.swift
//  Picterest
//
//  Created by 장주명 on 2022/07/30.
//

import Foundation

enum CoreDataStorageError: Error{
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
    
    var errorDescription : String {
        switch self {
        case .readError :
            return "데이터를 읽어오는데 실패하였습니다."
        case .saveError:
            return "데이터를 저장하는데 실패하였습니다."
        case .deleteError :
            return "데이터를 삭제하는데 실패하였습니다."
        }
    }
}
