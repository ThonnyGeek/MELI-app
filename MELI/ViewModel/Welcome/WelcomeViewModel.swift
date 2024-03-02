//
//  WelcomeViewModel.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import Foundation
import Combine
import SwiftUI

final class WelcomeViewModel: ObservableObject, MELIBasicViewModel {
    
    //MARK: Variables
    @Published var sites: [SitesModelElement] = [] {
        didSet {
            if !sites.isEmpty {
                showReloadButton = false
            }
        }
    }
    
    @Published var lastApiError: NetworkErrorHandler?
    
    @Published var showReloadButton: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: Constants
    let welcomeServices: WelcomeServicesProtocol
    
    //MARK: init
    init(welcomeServices: WelcomeServicesProtocol) {
        
        self.welcomeServices = welcomeServices
        
        /// Adding startup "animation": Waits 1 sec to make the call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.fetchSites()
        }
    }
    
    //MARK: Functions
    func fetchSites() {
        welcomeServices.fetchSites()
            .sink { [weak self] completion in
                guard let apiError = self?.onReceive(completion) else {
                    return
                }
                self?.lastApiError = apiError
                self?.showReloadButton = true
            } receiveValue: { [weak self] sitesValue in
                guard let self = self else { return }
                withAnimation {
                    self.sites = sitesValue.sorted { $0.name < $1.name }
                }
            }
            .store(in: &cancellables)
    }
    
    func reloadButtonTapAction() {
        showReloadButton = false
        fetchSites()
    }
}
