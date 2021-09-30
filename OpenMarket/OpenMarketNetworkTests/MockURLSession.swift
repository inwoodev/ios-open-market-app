//
//  MockURLSession.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/06/01.
//

import UIKit
@testable import OpenMarket
final class MockURLSession: URLSessionProtocol {
    
    private var buildRequestFail: Bool = false
    private var isImageOnly: Bool = false

    
    init(buildRequestFail: Bool = false, isImageOnly: Bool = false) {
        self.buildRequestFail = buildRequestFail
        self.isImageOnly = isImageOnly
    }
    
    var sessionDataTask: MockURLSessionDataTask?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        guard let url = request.url else {
            return URLSessionDataTask()
            
        }
        let successfulResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil)
        
        let failureResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: "2", headerFields: nil)
        let sessionDataTask = MockURLSessionDataTask()
        let error = NetworkResponseError.failed
        
        guard let dataAsset = NSDataAsset.init(name: "Item"),
              let pencilImage = UIImage(systemName: "pencil"),
              let dummy_image_data = pencilImage.pngData() else {
            return URLSessionDataTask()
        }
        
        let stub_item_data = dataAsset.data
        
        sessionDataTask.resumeDidCall = {
            if self.buildRequestFail {
                completionHandler(nil, failureResponse, error)
            } else if self.isImageOnly {
                completionHandler(dummy_image_data, successfulResponse, nil)
            }
            else {
                completionHandler(stub_item_data, successfulResponse, nil)
            }
        }
        sessionDataTask.cancelDidCall = {
            completionHandler(nil, failureResponse, error)
        }
        
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}
