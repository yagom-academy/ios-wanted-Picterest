//
//  CustomError.swift
//  Picterest
//
//  Created by 김기림 on 2022/07/25.
//

import Foundation

enum CustomError: Error {
    case makeURLError
    case noData
    case responseError(code:Int)
    case error(error: Error?)
    case decodingError
    
    var description: String {
        switch self {
        case .makeURLError:
            return "URL 에러"
        case .noData:
            return "데이터가 없습니다."
        case .responseError(code: let code):
            return "리스폰에러 응답코드: \(code)"
        case .error(error: let error):
            guard let error = error else {
                return "알수없는 에러 발생"
            }
            return "에러: \(error.localizedDescription)"
        case .decodingError:
            return "디코딩 에러"
        }
    }
}
