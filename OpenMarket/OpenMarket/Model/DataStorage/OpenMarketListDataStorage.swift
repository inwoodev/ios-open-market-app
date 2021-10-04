//
//  OpenMarketDataStorage.swift
//  OpenMarket
//
//  Created by James on 2021/10/01.
//

import Foundation

final class OpenMarketListDataStorage {
    typealias startItemCount = Int
    typealias totalItemCount = Int
    
    private var openMarketItems: [OpenMarketItem] = []
    private let dataManager: OpenMarketDataManageable
    
    init(dataManager: OpenMarketDataManageable) {
        self.dataManager = dataManager
    }
    
    convenience init() {
        let dataManager = OpenMarketDataManager(dataParser: DataParser())
        self.init(dataManager: dataManager)
    }
    
    func accessOpenMarketItemList() -> [OpenMarketItem] {
        return openMarketItems
    }
    
    func accessItem(at index: Int) -> OpenMarketItem {
        return openMarketItems[index]
    }
    
    func insertOpenMarketItemList(page: Int, completion: @escaping ([OpenMarketItem], startItemCount, totalItemCount) -> ()) {
        dataManager.getOpenMarketItemModel(serverAPI: .itemList(page)) { [weak self] (itemList: OpenMarketItemList) in
            let startItemCount = self?.openMarketItems.count ?? 0
            let totalItemCount = startItemCount + itemList.items.count
            
            self?.openMarketItems.append(contentsOf: itemList.items)
            
            completion(self?.openMarketItems ?? [], startItemCount, totalItemCount)
        }
    }
    
    func removeAllOpenMarketItemList() {
        openMarketItems.removeAll()
    }
}
