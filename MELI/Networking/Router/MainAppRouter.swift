//
//  MainAppRouter.swift
//  MELI
//
//  Created by Thony Gonzalez on 28/02/24.
//

import Foundation

enum MainAppRouter: NetworkRouter {
    case fetchItemListByQuery(query: String)
    case loadMoreItemListByQuery(query: String, offset: String)
    case getItemDetail(id: String)
    
    var path: String {
        switch self {
        case .fetchItemListByQuery, .loadMoreItemListByQuery:
            if let siteId = UserDefaults.standard.string(forKey: "site_id") {
                return "/sites/\(siteId.description)/search"
            } else {
                return "/sites/MCO/search"
            }
        case .getItemDetail:
            return "/items"
        }
    }
    
    var method: HTTPsMethod {
        switch self {
        case .fetchItemListByQuery, .loadMoreItemListByQuery, .getItemDetail:
            return .get
        }
    }
    
    func asURLRequest() -> URLRequest? {
        
        guard let baseURL = URL(string: Constants.baseURL + path) else {
            return nil
        }
        
        switch self {
        case .fetchItemListByQuery(let query):
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "q", value: query)]
            
            guard let finalURL = components?.url else {
                return nil
            }

            var request = URLRequest(url: finalURL)
            request.cachePolicy = .useProtocolCachePolicy
            request.httpMethod = method.rawValue
            return request
            
        case .loadMoreItemListByQuery(let query, let offset):
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "offset", value: offset)
            ]
            
            guard let finalURL = components?.url else {
                return nil
            }

            var request = URLRequest(url: finalURL)
            request.cachePolicy = .useProtocolCachePolicy
            request.httpMethod = method.rawValue
            return request
            
        case .getItemDetail(let id):
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
            components?.queryItems = [URLQueryItem(name: "ids", value: id)]
            
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
