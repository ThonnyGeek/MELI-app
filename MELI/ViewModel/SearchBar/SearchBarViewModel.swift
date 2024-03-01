//
//  SearchBarViewModel.swift
//  MELI
//
//  Created by Thony Gonzalez on 28/02/24.
//

import Foundation
import Combine
import SwiftUI

final class SearchBarViewModel: ObservableObject {
    
    //MARK: Variables
    @Published var searchBarText: String = ""
    @Published var searchItemsResults: [Result] = []
    @Published var isLoading: Bool = false
    @Published var pagingResults: Paging = Paging(total: 0, primaryResults: 0, offset: 0, limit: 50)
    @Published var itemDetail: Result?
    
    @Published var sheetContentHeight = CGFloat(0)
    
    //MARK: Constants
    let mainAppService: MainAppService = MainAppService()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: init
    
    //MARK: Functions
    func fetchSearchItems(onFail: ((_ apiError: NetworkErrorHandler) -> Void)? = nil) {
        isLoading = true
        mainAppService.fetchSearchItems(query: searchBarText)
            .sink { [weak self] completion in
                
                self?.isLoading = false
                
                guard let apiError = API.shared.onReceive(completion), let onFail = onFail else {
                    return
                }
                onFail(apiError)
            } receiveValue: { [weak self] returnedSearchItemsModel in
                
                self?.isLoading = false
                
                print("returnedSearchItemsModel: \(returnedSearchItemsModel)")
                guard let self = self, let returnedSearchItemsModelResults = returnedSearchItemsModel.results else {
                    print("ERROR")
                    return
                }
                
                self.pagingResults = returnedSearchItemsModel.paging
                
                if returnedSearchItemsModelResults.isEmpty, let onFail = onFail {
                    onFail(NetworkErrorHandler.customError(APIError(error: "Búsqueda sin resultados", message: "Por favor intenta con otra palabra")))
                } else {
                    withAnimation {
                        self.searchItemsResults = returnedSearchItemsModelResults
                    }
                }
            }
            .store(in: &cancellables)
        
    }
    
    func loadMoreSearchItems(onFail: ((_ apiError: NetworkErrorHandler) -> Void)? = nil) {
        
        var offset = 0
        
        if pagingResults.offset == 0 {
            offset = 50
        } else {
            offset = pagingResults.offset + 50
        }
        print("query: \(searchBarText), offset: \(offset)")
        print("pagingResults: \(pagingResults)")
        print("searchItemsResults.count: \(searchItemsResults.count)")
        
        
        mainAppService.loadMoreSearchItems(query: searchBarText, offset: "\(offset)")
            .sink { completion in
                guard let apiError = API.shared.onReceive(completion), let onFail = onFail else {
                    return
                }
                onFail(apiError)
            } receiveValue: { [weak self] returnedSearchItemsModel in
                guard let self = self, let returnedSearchItemsModelResults = returnedSearchItemsModel.results else {
                    print("ERROR")
                    return
                }
                
                if returnedSearchItemsModelResults.isEmpty, let onFail = onFail {
                    onFail(NetworkErrorHandler.customError(APIError(error: "Búsqueda sin resultados", message: "Por favor intenta con otra palabra")))
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
