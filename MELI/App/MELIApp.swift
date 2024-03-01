//
//  MELIApp.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import SwiftUI

@main
struct MELIApp: App {
    @StateObject var inAppNotificationsViewModel: InAppNotificationsViewModel = InAppNotificationsViewModel()

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .overlay {
                    InAppNotificationsView()
                    
                    LoadingView(show: inAppNotificationsViewModel.showLoadingView)
                }
                .environmentObject(inAppNotificationsViewModel)
        }
    }
}
