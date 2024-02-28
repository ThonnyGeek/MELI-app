//
//  WelcomeViewModel.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import Foundation
import Combine
import SwiftUI

final class WelcomeViewModel: ObservableObject {
    
    //MARK: Variables
    @Published var sites: [SitesModelElement] = []
    
    @Published var lastApiError: NetworkErrorHandler?
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Constants
    let welcomeServices: WelcomeServices = WelcomeServices()
    
    //MARK: init
    init() {
        /// Adding startup "animation": Waits 1 sec to make the call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchSites { apiError in
                self.lastApiError = apiError
            }
        }
    }
    
    //MARK: Functions
    func fetchSites(onFail: ((_ apiError: NetworkErrorHandler) -> Void)? = nil) {
        print("viewModel.fetchSites()")
        welcomeServices.fetchSites()
            .sink { (completion) in
                guard let apiError = API.shared.onReceive(completion), let onFail = onFail else {
                    return
                }
                onFail(apiError)
            } receiveValue: { [weak self] sitesValue in
                guard let self = self else { return }
                withAnimation {
                    self.sites = sitesValue
                }
            }
            .store(in: &cancellables)
    }
}
