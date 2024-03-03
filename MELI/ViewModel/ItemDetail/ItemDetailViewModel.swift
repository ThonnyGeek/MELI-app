//
//  ItemDetailViewModel.swift
//  MELI
//
//  Created by Thony Gonzalez on 29/02/24.
//

import Foundation
import Combine

final class ItemDetailViewModel: ObservableObject, MELIBasicViewModel {
    //MARK: Variables
    @Published var lastApiError: NetworkErrorHandler?
    private var cancellables = Set<AnyCancellable>()
    @Published var itemDetailData: ItemDetailBody?
    @Published var showPicsView: Bool = false
    
    //MARK: Constants
    let mainAppService: MainAppServiceProtocol
    let itemId: String
    
    //MARK: init
    init(mainAppService: MainAppServiceProtocol, itemId: String) {
        self.mainAppService = mainAppService
        self.itemId = itemId
        getItemDetail()
    }
    
    //MARK: Functions
    func calculateDiscountPercentage(originalValue: Double, valueWithDiscount: Double) -> String {
        guard originalValue > valueWithDiscount else {
            return String(format: "%.f", 0.0)
        }

        let discount = originalValue - valueWithDiscount
        let discountPercentage = (discount / originalValue) * 100.0

        return String(format: "%.f", discountPercentage)
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
    
    func getItemDetail() {
        mainAppService.getItemDetail(id: itemId)
            .sink { [weak self] completion in
                guard let apiError = self?.onReceive(completion) else {
                    return
                }
                self?.lastApiError = apiError
            } receiveValue: { [weak self] returnedItemDetail in
                guard let returnedItemDetail = returnedItemDetail else {
                    self?.lastApiError = .customError(APIError(error: "Error al obtener item detail", message: "Por favor intentalo nuevamente"))
                    return
                }
                self?.itemDetailData = returnedItemDetail.body
            }
            .store(in: &cancellables)
    }
}

