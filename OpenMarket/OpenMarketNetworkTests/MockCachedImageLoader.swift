//
//  MockCachedImageLoader.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/09/28.
//

import UIKit
@testable import OpenMarket

final class MockCachedImageLoader: CachedImageLoadable {
    var mock_image_downloader: ImageDownloadable
    var imageCacheCounter = 0
    var loadImageWithCacheDidCall: () -> Void = { }
    var cancelLoadingDidCall: () -> Void = { }
    
    init(mock_image_downloader: ImageDownloadable) {
        self.mock_image_downloader = mock_image_downloader
    }
    
    func loadImageWithCache(with link: String, completion: @escaping (UIImage) ->()) {
        let nsText = link as NSString
        
        if let cachedImage = CacheManager.shared.cache[nsText] {
            return completion(cachedImage)
        }
        
        mock_image_downloader.downloadImage(url: link.createURL()) { result in
            switch result {
            case .failure(_):
                return
            case .success(let image):
                CacheManager.shared.cache.insert(image, forkey: nsText)
                self.imageCacheCounter += 1
                self.loadImageWithCacheDidCall()
                return completion(image)
            }
        }
        
    }
    
    func cancelLoading() {
        mock_image_downloader.cancelDownloading()
        cancelLoadingDidCall()
    }
    
    
}
