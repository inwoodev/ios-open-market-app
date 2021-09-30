//
//  BuildRequestTest.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/09/27.
//

import XCTest
@testable import OpenMarket
final class BuildRequestTest: XCTestCase {
    var sut_request_builder: RequestBuildable!
    var stub_openMarket_server_API: OpenMarketServerAPI<Int>!
    var dummy_http_method: HTTPMethods!
    var dummy_itemID: Int!
    var stub_headerField: String!
    var stub_value: String!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // given
        sut_request_builder = RequestBuilder()
        stub_headerField = "Content-Type"
        stub_value = "multipart/form-data;boundary = Boundary-(uuidString)"
        
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        dummy_http_method = nil
        stub_openMarket_server_API = nil
        dummy_itemID = nil
        stub_headerField = nil
        stub_value = nil
        
    }

    func test_correct_url_in_request() {
        
        // given
        dummy_http_method = .get
        dummy_itemID = 1
        stub_openMarket_server_API = .singleItemToGetPatchOrDelete(dummy_itemID)
        
        // when
        let request = sut_request_builder.buildRequest(url: stub_openMarket_server_API.URL, httpMethod: dummy_http_method, httpBody: nil, headerField: nil, value: nil)
        
        // then
        XCTAssertNotNil(request.url)
        XCTAssertEqual(request.url, stub_openMarket_server_API.URL)
        
    }
    
    func test_correct_httpMethod_post_in_request() {
        
        // given
        let stub_get_method = HTTPMethods.get
        let stub_post_method = HTTPMethods.post
        let stub_patch_method = HTTPMethods.patch
        let stub_delete_method = HTTPMethods.delete
        dummy_itemID = 23
        stub_openMarket_server_API = .singleItemToGetPatchOrDelete(dummy_itemID)
        
        // when
        let getRequest = sut_request_builder.buildRequest(url: stub_openMarket_server_API.URL, httpMethod: stub_get_method, httpBody: nil, headerField: nil, value: nil)
        let postRequest = sut_request_builder.buildRequest(url: stub_openMarket_server_API.URL, httpMethod: stub_post_method, httpBody: nil, headerField: nil, value: nil)
        let patchRequest = sut_request_builder.buildRequest(url: stub_openMarket_server_API.URL, httpMethod: stub_patch_method, httpBody: nil, headerField: nil, value: nil)
        let deleteRequest = sut_request_builder.buildRequest(url: stub_openMarket_server_API.URL, httpMethod: stub_delete_method, httpBody: nil, headerField: nil, value: nil)
        
        // then
        XCTAssertEqual(getRequest.httpMethod, "GET")
        XCTAssertEqual(postRequest.httpMethod, "POST")
        XCTAssertEqual(patchRequest.httpMethod, "PATCH")
        XCTAssertEqual(deleteRequest.httpMethod, "DELETE")
    }
    
    func test_correct_headerField_and_value_in_request() {
        
        // given
        dummy_itemID = 32
        dummy_http_method = .patch
        stub_openMarket_server_API = .singleItemToGetPatchOrDelete(dummy_itemID)
        
        // when
        let request = sut_request_builder.buildRequest(url: stub_openMarket_server_API.URL, httpMethod: dummy_http_method, httpBody: nil, headerField: stub_headerField, value: stub_value)
        
        // then
        XCTAssertEqual(request.value(forHTTPHeaderField: stub_headerField), stub_value)
        XCTAssertEqual(request.allHTTPHeaderFields, [stub_headerField: stub_value])
    }
}
