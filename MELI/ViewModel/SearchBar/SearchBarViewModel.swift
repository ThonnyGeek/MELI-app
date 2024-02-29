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
