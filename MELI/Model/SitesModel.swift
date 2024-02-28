//
//  SitesModel.swift
//  MELI
//
//  Created by Thony Gonzalez on 27/02/24.
//

import Foundation

// MARK: - SitesModelElement
struct SitesModelElement: Codable, Hashable {
    let defaultCurrencyID, id, name: String

    enum CodingKeys: String, CodingKey {
        case defaultCurrencyID = "default_currency_id"
        case id, name
    }
}

typealias SitesModel = [SitesModelElement]
