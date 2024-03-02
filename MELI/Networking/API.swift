//
//  APIClient.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import Foundation
import Combine

struct APIClient {
    @discardableResult
    /// Here we handle APIClient errors
    func publisher<T>(_ request: URLRequest?, decodingType: T.Type) -> AnyPublisher<T, NetworkErrorHandler> where T: Decodable {
        
        guard let newRequest = request else {
            return Fail(error: NetworkErrorHandler.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: newRequest)
            .tryMap({ result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw NetworkErrorHandler.requestFailed
                }
                
                if (200..<300) ~= httpResponse.statusCode {
                    return result.data
                } else if httpResponse.statusCode == 401 {
                    throw NetworkErrorHandler.tokenExpired
                } else {
                    if let error = try? JSONDecoder().decode(APIError.self, from: result.data) {
                        throw NetworkErrorHandler.APIError(error)
                    } else {
                        throw NetworkErrorHandler.emptyErrorWithStatusCode(httpResponse.statusCode.description)
                    }
                }
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error -> NetworkErrorHandler in
                print("Handling error: \(error)")
                if let error = error as? NetworkErrorHandler {
                    return error
                }
                return NetworkErrorHandler.normalError(error)
            })
        /// Timeout to cancel the request if it has a long response time
            .timeout(10, scheduler: DispatchQueue.main, customError: {
                NetworkErrorHandler.APIError(APIError(error: "Request cancelled", message: "The request took too long to complete due to issues with the APIClient server"))
            })
            .eraseToAnyPublisher()
    }
}
