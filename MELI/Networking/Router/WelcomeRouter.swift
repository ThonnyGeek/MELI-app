//
//  WelcomeRouter.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import Foundation

enum WelcomeRouter: NetworkRouter {
    case fetchSites
    
    var path: String {
        switch self {
        case .fetchSites:
            return "/sites"
        }
    }
    
    var method: HTTPsMethod {
        switch self {
        case .fetchSites:
            return .get
        }
    }
    
    func asURLRequest() -> URLRequest? {
        guard let baseURL = URL(string: Constants.baseURL + path) else {
                return nil
        }

        var request = URLRequest(url: baseURL)
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = method.rawValue
        return request
    }
}
