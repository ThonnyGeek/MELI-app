//
//  MELIApp.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import SwiftUI

@main
struct MELIApp: App {
    
    let dependencies = AppDependency()
    
    @StateObject var inAppNotificationsViewModel: InAppNotificationsViewModel = InAppNotificationsViewModel()

    var body: some Scene {
        WindowGroup {
            WelcomeView(mainAppService: dependencies.mainAppService, welcomeServices: dependencies.welcomeServices)
                .overlay {
                    InAppNotificationsView()
                    
                    LoadingView(show: inAppNotificationsViewModel.showLoadingView)
                }
                .environmentObject(inAppNotificationsViewModel)
        }
    }
}
