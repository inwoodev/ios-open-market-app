//
//  OpenMarketMultipartFormDataStorage.swift
//  OpenMarket
//
//  Created by James on 2021/10/01.
//

import UIKit

final class OpenMarketMultipartFormDataStorage {
    
    enum Currency: CustomStringConvertible {
        case krw, usd, btc, jpy, eur, gbp, cny
        
        var description: String {
            switch self {
            case .krw:
                return "KRW"
            case .usd:
                return "USD"
            case .btc:
                return "BTC"
            case .jpy:
                return "JPY"
            case .eur:
                return "EUR"
            case .gbp:
                return "GBP"
            case .cny:
                return "CNY"
            }
        }
    }
    
    private let currencyList: [Currency] = [.krw, .usd, .btc, .jpy, .eur, .gbp, .cny]
    private var itemImages: [UIImage] = []
    private var itemInformation: [String: Any?] = [:]
    private let dataManager: OpenMarketDataManageable
    
    init(dataManager: OpenMarketDataManageable) {
        self.dataManager = dataManager
    }
    
    convenience init() {
        let dataManager = OpenMarketDataManager(multipartFormDataConverter: MultipartFormDataConverter())
        self.init(dataManager: dataManager)
    }
    
    func accessItemImages() -> [UIImage] {
        return itemImages
    }
    
    func accessItemInformation() -> [String: Any?] {
        return itemInformation
    }
    
    func accessCurrencyList() -> [Currency] {
        return currencyList
    }
    
    func getCurrency(at row: Int) -> Currency {
        return currencyList[row]
    }
    
    func addImages(_ images: [UIImage]) {
        itemImages.append(contentsOf: images)
    }
    
    func removeImage(at index: Int) {
        itemImages.remove(at: index)
    }
    
    func updateItemInformation(_ value: Any?, forKey key: String) {
        itemInformation.updateValue(value, forKey: key)
    }
    
    func postOpenMarketItem(completion: @escaping (HTTPURLResponse) -> ()) {
        dataManager.postOpenMarketItemData(serverAPI: .singleItemToPost, texts: itemInformation, imageList: itemImages) { response in
            completion(response)
        }
    }
    
    func patchOpenMarketItem(id: Int, completion: @escaping (HTTPURLResponse) -> ()) {
        dataManager.patchOpenMarketItemData(serverAPI: .singleItemToGetPatchOrDelete(id), texts: itemInformation, imageList: itemImages) { response in
            completion(response)
        }
    }
}
