//
//  ImageLoadable.swift
//  OpenMarket
//
//  Created by James on 2021/09/18.
//

import UIKit

protocol ImageLoadable: AnyObject {
    typealias imageHandler = (Result<UIImage, Error>) -> ()
    
    func loadImage(with text: String, completion: @escaping imageHandler)
}
