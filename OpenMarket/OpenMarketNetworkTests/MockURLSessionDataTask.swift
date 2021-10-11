//
//  MockURLSessionDataTask.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/06/01.
//

import Foundation
@testable import OpenMarket

final class MockURLSessionDataTask: URLSessionDataTask {
    override init() { }
    var resumeDidCall: () -> Void = { }
    var cancelDidCall: () -> Void = { }
    
    override func resume() {
        resumeDidCall()
    }
    
    override func cancel() {
        cancelDidCall()
    }
}
