//
//  ImageDownloadable.swift
//  OpenMarket
//
//  Created by James on 2021/09/18.
//

import UIKit

protocol ImageDownloadable: AnyObject {
    var network: Networkable { get }
    typealias downloadHandler = (Result<UIImage, Error>) ->()
    
    func downloadImage(url: URL, completion: @escaping downloadHandler)
    func cancelDownloading()
}
