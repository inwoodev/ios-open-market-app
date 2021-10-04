//
//  OpenMarketItemInformationDataStorage.swift
//  OpenMarket
//
//  Created by James on 2021/10/01.
//

import UIKit

final class OpenMarketItemInformationDataStorage {
    private let dataManager: OpenMarketDataManageable
    private let cachedImageLoader: CachedImageLoadable
    private var sliderImages = [UIImage]()
    private var itemInformation: OpenMarketItemWithDetailInformation?
    
    init(dataManager: OpenMarketDataManageable, cachedImageLoader: CachedImageLoadable) {
        self.dataManager = dataManager
        self.cachedImageLoader = cachedImageLoader
    }
    
    convenience init() {
        let dataManager = OpenMarketDataManager()
        let imageLoader = CachedImageLoader()
        self.init(dataManager: dataManager, cachedImageLoader: imageLoader)
    }
    
    func accessSliderImages() -> [UIImage] {
        return sliderImages
    }
    
    func accessItemInformation() -> OpenMarketItemWithDetailInformation? {
        return itemInformation
    }
    
    func downloadImages(completion: @escaping ([UIImage]) -> Void) {
        guard let downloadedImageURLStrings = itemInformation?.thumbnails else {
            return
            
        }
        
        var imageArray = [UIImage]()
        let dispatchGroup = DispatchGroup()
        
        for urlString in downloadedImageURLStrings {
            dispatchGroup.enter()
            cachedImageLoader.loadImageWithCache(with: urlString) { image in
                imageArray.append(image)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.sliderImages.append(contentsOf: imageArray)
            completion(imageArray)
        }
    }
    
    func insertOpenMarketItemInformation(id: Int, completion: @escaping (OpenMarketItemWithDetailInformation) -> ()) {
        dataManager.getOpenMarketItemModel(serverAPI: .singleItemToGetPatchOrDelete(id)) { [weak self] (item: OpenMarketItemWithDetailInformation) in
            self?.itemInformation = item
            completion(item)
        }
    }
    
    func proceedToPatchOpenMarketItem(id: Int, password: String, completion: @escaping (HTTPURLResponse) -> ()) {
        dataManager.patchOpenMarketItemData(serverAPI: .singleItemToGetPatchOrDelete(id), texts: [OpenMarketItemToPostOrPatch.password.key: password], imageList: nil) { response in
            completion(response)
        }
    }
    
    func deleteOpenMarketItem(id: Int, password: String, completion: @escaping (HTTPURLResponse) -> ()) {
        dataManager.deleteItemData(serverAPI: .singleItemToGetPatchOrDelete(id), password: password) { response in
            completion(response)
        }
    }
}
