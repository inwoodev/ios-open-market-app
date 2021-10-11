//
//  URLAPI.swift
//  OpenMarket
//
//  Created by James on 2021/09/18.
//

import Foundation

enum OpenMarketServerAPI<Int> {
    case itemList(Int), singleItemToPost, singleItemToGetPatchOrDelete(Int)
    
    private var baseURL: String {
            return "https://camp-open-market-2.herokuapp.com"
    }
    
    var URL: URL {
        switch self {
        case .itemList(let page):
            return "\(baseURL)/items/\(page)".createURL()
        case .singleItemToPost:
            return "\(baseURL)/item".createURL()
        case .singleItemToGetPatchOrDelete(let id):
            return "\(baseURL)/item/\(id)".createURL()
        }
    }
}
