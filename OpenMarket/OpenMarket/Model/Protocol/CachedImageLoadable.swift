//
//  ImageLoadable.swift
//  OpenMarket
//
//  Created by James on 2021/09/18.
//

import UIKit

protocol CachedImageLoadable: AnyObject {
    func loadImageWithCache(with link: String, completion: @escaping (UIImage) ->())
    func cancelLoading()
}
