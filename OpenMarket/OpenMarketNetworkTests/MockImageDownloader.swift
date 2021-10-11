//
//  MockImageDownloader.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/09/28.
//

import UIKit
@testable import OpenMarket

final class MockImageDownloader: ImageDownloadable {
    let network: Networkable
    var downloadImageDidCall: () -> Void = { }
    var cancelDownloadingDidCall: () -> Void = { }
    init(network: Networkable) {
        self.network = network
    }
    
    func downloadImage(url: URL, completion: @escaping downloadHandler) {
        let request = URLRequest(url: url)
        network.load(request: request) { data, response, error in
            if response?.statusCode == 200 {
                self.downloadImageDidCall()
                completion(.success(UIImage()))
            } else {
                if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func cancelDownloading() {
        network.cancel()
        self.cancelDownloadingDidCall()
    }
    
    
}
