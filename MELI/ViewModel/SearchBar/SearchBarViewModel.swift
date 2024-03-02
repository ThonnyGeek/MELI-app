//
//  SearchBarViewModel.swift
//  MELI
//
//  Created by Thony Gonzalez on 28/02/24.
//

import Foundation
import Combine
import SwiftUI

final class SearchBarViewModel: ObservableObject, MELIBasicViewModel {
    
    //MARK: Variables
    @Published var searchBarText: String = ""
    @Published var searchItemsResults: [Result] = []
    @Published var isLoading: Bool = false
    @Published var pagingResults: Paging = Paging(total: 0, primaryResults: 0, offset: 0, limit: 50)
    @Published var itemDetail: Result?
    
    @Published var lastApiError: NetworkErrorHandler?
    
    //MARK: Constants
    let mainAppService: MainAppServiceProtocol// = MainAppService()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: init
    init(mainAppService: MainAppServiceProtocol) {
        self.mainAppService = mainAppService
    }
    
    //MARK: Functions
    func fetchSearchItems() {
        isLoading = true
        mainAppService.fetchSearchItems(query: searchBarText)
            .sink { [weak self] completion in
                
                self?.isLoading = false
                
                guard let apiError = self?.onReceive(completion) else {
                    return
                }
                self?.lastApiError = apiError
            } receiveValue: { [weak self] returnedSearchItemsModel in
                
                self?.isLoading = false
                
                guard let returnedSearchItemsModelResults = returnedSearchItemsModel.results else {
                    self?.lastApiError = .customError(APIError(error: "Error al realizar la búsqueda", message: "Por favor intenta de nuevo"))
                    return
                }
                
                self?.pagingResults = returnedSearchItemsModel.paging
                
                if returnedSearchItemsModelResults.isEmpty {
                    self?.lastApiError = .customError(APIError(error: "Búsqueda sin resultados", message: "Por favor intenta con otra palabra"))
                } else {
                    withAnimation {
                        self?.searchItemsResults = returnedSearchItemsModelResults
                    }
                }
            }
            .store(in: &cancellables)
        
    }
    
    func loadMoreSearchItems() {
        
        var offset = 0
        
        if pagingResults.offset == 0 {
            offset = 50
        } else {
            offset = pagingResults.offset + 50
        }
        
        mainAppService.loadMoreSearchItems(query: searchBarText, offset: "\(offset)")
            .sink { [weak self] completion in
                guard let apiError = self?.onReceive(completion) else {
                    return
                }
                self?.lastApiError = apiError
            } receiveValue: { [weak self] returnedSearchItemsModel in
                guard let self = self, let returnedSearchItemsModelResults = returnedSearchItemsModel.results else {
                    self?.lastApiError = .customError(APIError(error: "Búsqueda sin resultados", message: "Por favor intenta con otra palabra"))
                    return
                }
                
                if returnedSearchItemsModelResults.isEmpty {
                    self.lastApiError = .customError(APIError(error: "Búsqueda sin resultados", message: "Por favor intenta con otra palabra"))
                } else {
                    withAnimation {
                        self.searchItemsResults.append(contentsOf: returnedSearchItemsModelResults)
                    }
                    
                    self.pagingResults = returnedSearchItemsModel.paging
                }
            }
            .store(in: &cancellables)
        
    }
    
    func formatAsMoney(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_CO") // Puedes ajustar la localización según tus necesidades
        
        guard let result = formatter.string(from: NSNumber(value: number)) else {
            return number.description
        }
        
        return result
    }
    
    func resetFields() {
        withAnimation {
            searchBarText = ""
            searchItemsResults = []
        }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
