//
//  ItemDetailViewModel.swift
//  MELI
//
//  Created by Thony Gonzalez on 29/02/24.
//

import Foundation

final class ItemDetailViewModel: ObservableObject {
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
}
