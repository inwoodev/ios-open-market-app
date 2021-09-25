//
//  UIImageView+Extension.swift
//  OpenMarket
//
//  Created by James on 2021/09/24.
//

import UIKit

extension UIImageView {
    private var imageLoader: CachedImageLoader {
        return CachedImageLoader(imageDownloader: ImageDownloader(network: Network()))
    }
    
    func applyDownloadedImage(link: String) {
        imageLoader.loadImageWithCache(with: link) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
