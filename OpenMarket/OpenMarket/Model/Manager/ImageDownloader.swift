//
//  ImageDownloader.swift
//  OpenMarket
//
//  Created by James on 2021/09/17.
//

import UIKit

final class ImageDownloader: ImageDownloadable {
    typealias downloadHandler = (Result<UIImage, Error>) ->()
    private let network: Networkable?
    
    init(network: Networkable) {
        self.network = network
    }
    
    func downloadImage(url: URL, completion: @escaping downloadHandler) {
        let request = URLRequest(url: url)
        network?.load(request: request, completion: { data, _, _ in
            guard let validData = data,
                  let image = UIImage(data: validData) else {
                      return completion(.failure(NetworkResponseError.badRequest))
                      
                  }
            return completion(.success(image))
            
        })
    }
    
    func cancelImageDownload() {
        network?.cancel()
    }
}
