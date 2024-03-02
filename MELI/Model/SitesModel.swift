//
//  SitesModel.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import Foundation

// MARK: - SitesModelElement
struct SitesModelElement: Codable, Hashable, Comparable {
    static func < (lhs: SitesModelElement, rhs: SitesModelElement) -> Bool {
        lhs.name < rhs.name
    }
    
    let defaultCurrencyID, id, name: String

    enum CodingKeys: String, CodingKey {
        case defaultCurrencyID = "default_currency_id"
        case id, name
    }
}

typealias SitesModel = [SitesModelElement]
