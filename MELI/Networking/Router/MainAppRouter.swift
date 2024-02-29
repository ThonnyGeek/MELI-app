//
//  MainAppRouter.swift
//  MELI
//
//  Created by Thony Gonzalez on 28/02/24.
//

import Foundation

enum MainAppRouter: NetworkRouter {
    case fetchItemListByQuery(query: String)
    
    var path: String {
        switch self {
        case .fetchItemListByQuery:
            if let siteId = UserDefaults.standard.string(forKey: "site_id") {
                return "/sites/\(siteId.description)/search"
            } else {
                return "/sites/MCO/search"
            }
        }
    }
    
    var method: HTTPsMethod {
        switch self {
        case .fetchItemListByQuery:
            return .get
        }
    }
    
    func asURLRequest() -> URLRequest? {
        
        guard let baseURL = URL(string: API.shared.baseURL + path) else {
            return nil
        }
        
        switch self {
        case .fetchItemListByQuery(let query):
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
            components?.queryItems = []
            components?.queryItems?.append(URLQueryItem(name: "q", value: query))
            
            guard let finalURL = components?.url else {
                return nil
            }

            var request = URLRequest(url: finalURL)
            request.cachePolicy = .useProtocolCachePolicy
            request.httpMethod = method.rawValue
            return request
        }
    }
}
