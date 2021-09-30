//
//  OpenMarketNetworkTests.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/05/31.
//

import XCTest
@testable import OpenMarket
final class OpenMarketNetworkTests: XCTestCase {
    var sut_network: Networkable!
    var mock_URLRequest: URLRequest!
    let firstPage = 1
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // given
        let itemListFirstPageAPI = OpenMarketServerAPI.itemList(firstPage).URL
        mock_URLRequest = URLRequest(url: itemListFirstPageAPI)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut_network = nil
        mock_URLRequest = nil

    }
    
    func test_networkResponse_loadFirstPageOfItemList_successfulResponse_receiveStatusCode200() {
        
        // given
        let expectation = XCTestExpectation()
        sut_network = Network(urlSession: MockURLSession())
    
        // when
        sut_network.load(request: mock_URLRequest) { _, response, _ in
            XCTAssertEqual(response?.statusCode, 200)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_networkResponse_loadFirstPageOfItemList_failureResponse_receiveStatusCode400() {
        
        // given
        let expectation = XCTestExpectation()
        sut_network = Network(urlSession: MockURLSession(buildRequestFail: true))
        
        
        // when
        sut_network.load(request: mock_URLRequest) { _, response, _ in
            XCTAssertEqual(response?.statusCode, 400)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_networkResponse_correctURL() {
        
        // given
        let expectation = XCTestExpectation()
        sut_network = Network(urlSession: MockURLSession())
        
        // when
        sut_network.load(request: mock_URLRequest) { _, response, _ in
            XCTAssertEqual(response?.url, self.mock_URLRequest.url)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func test_network_cancelLoading() {
        
        // given
        let expectation = XCTestExpectation()
        var spy_cancel_counter = 0
        let mock_URL_session_datatask = MockURLSessionDataTask()
        sut_network = Network(urlSession: MockURLSession(), dataTask: mock_URL_session_datatask)
        // when
        mock_URL_session_datatask.cancelDidCall = {
            spy_cancel_counter += 1
            expectation.fulfill()
        }
        sut_network.cancel()
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(spy_cancel_counter, 1)
    }
}
