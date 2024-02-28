//
//  NetworkRouter.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import Foundation

protocol NetworkRouter {
    var path: String { get }
    var method: HTTPsMethod { get }
    func asURLRequest() -> URLRequest?
}

enum HTTPsMethod {
    case get
    case post
    case delete
    
    var rawValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}
