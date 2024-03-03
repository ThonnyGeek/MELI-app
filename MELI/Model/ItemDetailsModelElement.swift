//
//  ItemDetailsModelElement.swift
//  MELI
//
//  Created by Thony Gonzalez on 2/03/24.
//

import Foundation

typealias ItemDetailsModel = [ItemDetailsModelElement]

// MARK: - ItemDetailsModelElement
struct ItemDetailsModelElement: Codable {
    let code: Int
    let body: ItemDetailBody
}

// MARK: - ItemDetailBody
struct ItemDetailBody: Codable {
    let id: String?
    let message: String?
    let title: String?
    let price, originalPrice: Int?
    let condition: String?
    let thumbnailID: String?
    let thumbnail: String?
    let pictures: [Picture]?
    let shipping: Shipping?
    let attributes: [Attribute]?
    /*
     let siteID: String?
     let sellerID: Int?
     let categoryID: String?
     let basePrice: Int?
     let buyingMode, listingTypeID
     let currencyID: String?
     let initialQuantity: Int?
     let saleTerms: [Attribute]?
     let permalink: String?
     let acceptsMercadopago: Bool?
     let internationalDeliveryMode: String?
     let sellerAddress: SellerAddress?
     let listingSource: String?
     let status: String?
     let tags: [String]?
     let warranty, catalogProductID, domainID: String?
     let dealIDS: [String]?
     let automaticRelist: Bool?
     let dateCreated, lastUpdated: String?
     let catalogListing: Bool?
    */

    enum CodingKeys: String, CodingKey {
        case id
        case message
        case title
        case price
        case originalPrice = "original_price"
        case condition
        case thumbnailID = "thumbnail_id"
        case thumbnail, pictures
        case shipping
        case attributes
        /*
         case listingTypeID = "listing_type_id"
         case siteID = "site_id"
         case sellerID = "seller_id"
         case categoryID = "category_id"
         case basePrice = "base_price"
         case currencyID = "currency_id"
         case initialQuantity = "initial_quantity"
         case saleTerms = "sale_terms"
         case buyingMode = "buying_mode"
         case permalink
         case acceptsMercadopago = "accepts_mercadopago"
         case internationalDeliveryMode = "international_delivery_mode"
         case sellerAddress = "seller_address"
         case listingSource = "listing_source"
         case status
         case tags, warranty
         case catalogProductID = "catalog_product_id"
         case domainID = "domain_id"
         case dealIDS = "deal_ids"
         case automaticRelist = "automatic_relist"
         case dateCreated = "date_created"
         case lastUpdated = "last_updated"
         case catalogListing = "catalog_listing"
         */
    }
}

// MARK: - Picture
struct Picture: Codable, Hashable {
    let id: String?
    let url: String?
    let secureURL: String?
    let size, maxSize, quality: String?

    enum CodingKeys: String, CodingKey {
        case id, url
        case secureURL = "secure_url"
        case size
        case maxSize = "max_size"
        case quality
    }
}

/*
 // MARK: - Struct
 struct Struct: Codable {
     let number: Double?
     let unit: String?
 }

 enum ValueType: String, Codable {
     case boolean = "boolean"
     case list = "list"
     case number = "number"
     case numberUnit = "number_unit"
     case string = "string"
 }

 // MARK: - Value
 struct Value: Codable {
     let id: String?
     let name: String?
     let valueStruct: Struct?

     enum CodingKeys: String, CodingKey {
         case id, name
         case valueStruct = "struct"
     }
 }
 
 // MARK: - SellerAddress
 struct SellerAddress: Codable {
     let city, state, country: City?
     let searchLocation: SearchLocation?
     let id: Int?

     enum CodingKeys: String, CodingKey {
         case city, state, country
         case searchLocation = "search_location"
         case id
     }
 }

 // MARK: - City
 struct City: Codable {
     let id, name: String?
 }

 // MARK: - SearchLocation
 struct SearchLocation: Codable {
     let neighborhood, city, state: City?
 }

 */
