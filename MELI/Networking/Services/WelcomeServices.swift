//
//  WelcomeServices.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import Foundation
import Combine

protocol WelcomeServicesProtocol {
    func fetchSites() -> AnyPublisher<SitesModel, NetworkErrorHandler>
}

class WelcomeServices: WelcomeServicesProtocol {
    func fetchSites() -> AnyPublisher<SitesModel, NetworkErrorHandler> {
        return API.shared.publisher(WelcomeRouter.fetchSites.asURLRequest(), decodingType: SitesModel.self)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
