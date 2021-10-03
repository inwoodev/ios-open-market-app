//
//  CacheManager.swift
//  OpenMarket
//
//  Created by James on 2021/09/26.
//

import UIKit

final class CacheManager {
    let cache = ImageCache<NSString, UIImage>(totalCostLimit: 500 * 1024 * 1024)
    
    static let shared = CacheManager()
    private init() { }
}
