//
//  OpenMarketDataManageable.swift
//  OpenMarket
//
//  Created by James on 2021/10/01.
//

import UIKit

protocol OpenMarketDataManageable {
    func getOpenMarketItemModel< U: Decodable> (serverAPI: OpenMarketServerAPI<Int>, completion: @escaping (U) -> ())
    func postOpenMarketItemData(serverAPI: OpenMarketServerAPI<Int>, texts: [String : Any?], imageList: [UIImage], completionHandler: @escaping (HTTPURLResponse) -> Void)
    func patchOpenMarketItemData(serverAPI: OpenMarketServerAPI<Int>, texts: [String : Any?], imageList: [UIImage]?, completionHandler: @escaping (HTTPURLResponse) -> Void)
    func deleteItemData(serverAPI: OpenMarketServerAPI<Int>, password: String, completionHandler: @escaping(HTTPURLResponse) -> Void)
}
