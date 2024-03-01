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
    
    @Published var showReloadButton: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Constants
    let welcomeServices: WelcomeServices = WelcomeServices()
    
    //MARK: init
    init() {
        /// Adding startup "animation": Waits 1 sec to make the call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchSites()
        }
    }
    
    //MARK: Functions
    func fetchSites() {
        print("viewModel.fetchSites()")
        welcomeServices.fetchSites()
            .sink { [weak self] completion in
                guard let apiError = API.shared.onReceive(completion) else {
                    return
                }
                self?.lastApiError = apiError
            } receiveValue: { [weak self] sitesValue in
                guard let self = self else { return }
                withAnimation {
                    self.sites = sitesValue.sorted { $0.name < $1.name }
                }
            }
            .store(in: &cancellables)
    }
}
