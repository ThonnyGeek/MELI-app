//
//  AppDependency.swift
//  MELI
//
//  Created by Thony Gonzalez on 1/03/24.
//

import Foundation

protocol HasClient {
    var client: APIClient { get }
}
protocol HasMainAppService {
    var mainAppService: MainAppService { get }
}

protocol HasWelcomeServices {
    var welcomeServices: WelcomeServices { get }
}

struct AppDependency: HasClient,
                      HasMainAppService,
                      HasWelcomeServices {

    let client: APIClient
    let mainAppService: MainAppService
    let welcomeServices: WelcomeServices

    init() {
        self.client = APIClient()
        self.mainAppService = MainAppService(client: client)
        self.welcomeServices = WelcomeServices(client: client)
    }
}
