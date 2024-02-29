//
//  MainAppService.swift
//  MELI
//
//  Created by Thony Gonzalez on 28/02/24.
//

import Foundation
import Combine

protocol MainAppServiceProtocol {
    func fetchSearchItems(query: String) -> AnyPublisher<SearchItemsModel, NetworkErrorHandler>
}

class MainAppService: MainAppServiceProtocol {
    func fetchSearchItems(query: String) -> AnyPublisher<SearchItemsModel, NetworkErrorHandler> {
        return API.shared.publisher(MainAppRouter.fetchItemListByQuery(query: query).asURLRequest(), decodingType: SearchItemsModel.self)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
