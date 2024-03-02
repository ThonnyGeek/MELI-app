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

class WelcomeServices {
    let client: APIClient

    init(client: APIClient) {
        self.client = client
    }
}

extension WelcomeServices: WelcomeServicesProtocol {
    
    func fetchSites() -> AnyPublisher<SitesModel, NetworkErrorHandler> {
        return client.publisher(WelcomeRouter.fetchSites.asURLRequest(), decodingType: SitesModel.self)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
