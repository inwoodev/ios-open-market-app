//
//  MockTest.swift
//  OpenMarketTests
//
//  Created by steven on 2021/05/21.
//

import XCTest
@testable import OpenMarket

class MockTest: XCTestCase {
    
    func test_상품_조회() {
        // given
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        let networkHelper = NetworkHelper(session: mockSession)
        
        guard let data = NSDataAsset(name: "item")?.data else {
            XCTFail()
            return
        }
        
        guard let mockJsonItem = try? JSONDecoder().decode(Product.self, from: data) else {
            XCTFail()
            return
        }
        
        MockURLProtocol.requsetHandler = { request in
            let response = HTTPURLResponse(url: URL(string: RequestAddress.readItem(id: 1).url)!, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (data, response, nil)
        }
        
        let promise = expectation(description: "Mock test")
        
        // when
        networkHelper.readItem(itemNum: 1) { result in
            
            // then
            switch result {
            case .success(let item):
                XCTAssertEqual(item.id, mockJsonItem.id)
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 2)
    }
    
    func test_상품_등록() {
        
        let mockItemForm = ProductForm(title: "수지", descriptions: "수지좋아", price: 1000, currency: "USD", stock: 90, discountedPrice: 999, images: [(UIImage(named: "vanilla")?.pngData())!], password: "1234")
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockSession = URLSession(configuration: configuration)
        let networkHelper = NetworkHelper(session: mockSession)
        
        let promise = expectation(description: "Mock test")
        
        MockURLProtocol.requsetHandler = { request in
            
            let mockJsonData = """
            {
                "id": 100,
                "title": "수지",
                "descriptions": "수지좋아",
                "price": 1000,
                "currency": "USD",
                "stock": 90,
                "thumbnails": [
                    "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png"
                ],
                "images": [
                    "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
                ],
                "registration_date": 1611523563.719116
            }
            """.data(using: .utf8)
            
            let response = HTTPURLResponse(url: URL(string: RequestAddress.createItem.url)!, statusCode: 200, httpVersion: nil, headerFields: nil)
                        
            return (mockJsonData, response, nil)
        }
        
        networkHelper.createItem(itemForm: mockItemForm) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.title, mockItemForm.title)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 2.0)
    }
}
