//
//  ImageLoader.swift
//  OpenMarket
//
//  Created by James on 2021/09/17.
//

import UIKit

final class CachedImageLoader: CachedImageLoadable {
    private let imageDownloader: ImageDownloadable
    
    
    init(imageDownloader: ImageDownloadable) {
        self.imageDownloader = imageDownloader
    }
    
    convenience init() {
        let imageDownloader = ImageDownloader()
        self.init(imageDownloader: imageDownloader)
    }
    
    func loadImageWithCache(with link: String, completion: @escaping (UIImage) ->()) {
        let nsText = link as NSString
        
        if let cachedImage = CacheManager.shared.cache[nsText] {
            return completion(cachedImage)
        }

        imageDownloader.downloadImage(url: link.createURL()) { result in
            switch result {
            case .failure(let error):
                NSLog(error.localizedDescription)
            case .success(let image):
                CacheManager.shared.cache.insert(image, forkey: nsText)
                return completion(image)
            }
        }
    }
    
    func cancelLoading() {
        imageDownloader.cancelDownloading()
    }
}
