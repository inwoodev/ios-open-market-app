//
//  OpenMarketItemToGet.swift
//  OpenMarket
//
//  Created by James on 2021/08/30.
//

import Foundation

struct OpenMarketItemWithDetailInformation: Decodable {
    var id: Int
    var title: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var descriptions: String
    var thumbnails: [String]
    var registrationDate: TimeInterval
    
    private enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails, descriptions
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
