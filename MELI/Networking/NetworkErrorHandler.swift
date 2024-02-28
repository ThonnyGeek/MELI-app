//
//  NetworkErrorHandler.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import Foundation

struct APIError: Codable {
    let error: String
    let message: String
}

enum NetworkErrorHandler: Error, Equatable {
    static func == (lhs: NetworkErrorHandler, rhs: NetworkErrorHandler) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    case APIError(APIError)
    case customError(APIError)
    case requestFailed
    case normalError(Error)
    case tokenExpired
    case emptyErrorWithStatusCode(String)
    case unauthenticated
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .APIError(let apiError), .customError(let apiError):
            return String(format: "%@ %@", apiError.error, apiError.message)
        case .requestFailed:
            return "Request failed"
        case .normalError(let error):
            return error.localizedDescription
        case .tokenExpired:
            return "Token problems"
        case .emptyErrorWithStatusCode(let status):
            return status
        case .unauthenticated:
            return "Unauthenticated"
        case .invalidURL:
            return "Invalid URL"
        }
    }
    
    var id: UUID {
        return UUID()
    }
    
//    var selfName: String {
//        switch self {
//        case .APIError(let aPIError):
//            return "API Error"
//        case .customError(let aPIError):
//            return "Custom Error"
//        case .requestFailed:
//            return "Request Failed"
//        case .normalError(let error):
//            return "Normal Error"
//        case .tokenExpired:
//            return "Token Expired"
//        case .emptyErrorWithStatusCode(let string):
//            return "Empty Error With Status Code"
//        case .unauthenticated:
//            return "Unauthenticated"
//        case .invalidURL:
//            return "Invalid URL"
//        }
//    }
}
