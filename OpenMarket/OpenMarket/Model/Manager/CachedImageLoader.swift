//
//  ImageLoader.swift
//  OpenMarket
//
//  Created by James on 2021/09/17.
//

import UIKit

let cache = ImageCache<NSString, UIImage>()

final class CachedImageLoader {
    
    private let imageDownloader: ImageDownloadable
    
    
    init(imageDownloader: ImageDownloadable) {
        self.imageDownloader = imageDownloader
    }
    
    func loadImageWithCache(with link: String, completion: @escaping (UIImage) ->()) {
        let nsText = link as NSString
        
        if let cachedImage = cache[nsText] {
            print("return cachedImage")
            return completion(cachedImage)
        }

        imageDownloader.downloadImage(url: link.createURL()) { result in
            switch result {
            case .failure(let error):
                NSLog(error.localizedDescription)
            case .success(let image):
                cache.insert(image, forkey: nsText)
                return completion(image)
            }
        }
    }
}
