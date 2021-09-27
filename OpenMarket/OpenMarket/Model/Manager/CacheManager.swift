//
//  CacheManager.swift
//  OpenMarket
//
//  Created by James on 2021/09/26.
//

import UIKit

final class CacheManager {
    static let cache = ImageCache<NSString, UIImage>(totalCostLimit: 500 * 1024 * 1024)
    private init() { }
}
