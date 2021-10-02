//
//  MockOpenMarketDataManager.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/10/02.
//

import UIKit
@testable import OpenMarket

final class MockOpenMarketDataManager: OpenMarketDataManageable {
    
    private let network: Networkable
    private let dataParser: DataParsible?
    private let multipartFormDataBuilder: MultipartFormDataBuildable?
    private let requestBuilder: RequestBuildable
    
    init(network: Networkable, dataParser: DataParsible?, multipartFormDataBuilder: MultipartFormDataBuildable?, requestBuilder: RequestBuildable) {
        self.network = network
        self.dataParser = dataParser
        self.multipartFormDataBuilder = multipartFormDataBuilder
        self.requestBuilder = requestBuilder
    }
    
    let stub_item_list = OpenMarketItemList(page: 1, items: [
        OpenMarketItem(id: 1, title: "stub_item1", price: 123, currency: "KRW", stock: 1, discountedPrice: 121, thumbnails: ["stub.com"], registrationDate: 12.32),
        OpenMarketItem(id: 2, title: "stub_item2", price: 123, currency: "KRW", stock: 2, discountedPrice: 123, thumbnails: ["stub2.com"], registrationDate: 12.332),
        OpenMarketItem(id: 3, title: "stub_item3", price: 124, currency: "USD", stock: 4, discountedPrice: 11, thumbnails: ["stub.com"], registrationDate: 12.32)
    ])
    
    let stub_item = OpenMarketItemWithDetailInformation(id: 1, title: "stub_item", price: 111, currency: "USD", stock: 2, discountedPrice: 110, descriptions: "stub_item_descriptions", thumbnails: ["stub.com"], registrationDate: 1233.32)
    
    func getOpenMarketItemModel<U>(serverAPI: OpenMarketServerAPI<Int>, completion: @escaping (U) -> ()) where U : Decodable {
        switch serverAPI {
        case .itemList(1):
            completion(stub_item_list as! U)
        case .singleItemToGetPatchOrDelete(1):
            completion(stub_item as! U)
        default:
            NSLog(DataError.decoding.description)
        }
    }
    
    func postOpenMarketItemData(serverAPI: OpenMarketServerAPI<Int>, texts: [String : Any?], imageList: [UIImage], completionHandler: @escaping (HTTPURLResponse) -> Void) {
        guard let boundary = multipartFormDataBuilder?.generateBoundary() else { return }
        
        let multipartFormData = self.multipartFormDataBuilder?.buildMultipartFormData(texts, imageList, boundary: boundary)
        let value = "multipart/form-data;boundary=\(boundary)"
        let request = requestBuilder.buildRequest(url: serverAPI.URL, httpMethod: .post, httpBody: multipartFormData, headerField: "Content-Type", value: value)
        
        network.load(request: request) { _, response, _ in
            guard let validResponse = response else { return }
            completionHandler(validResponse)
        }
    }
    
    func patchOpenMarketItemData(serverAPI: OpenMarketServerAPI<Int>, texts: [String : Any?], imageList: [UIImage]?, completionHandler: @escaping (HTTPURLResponse) -> Void) {
        guard let boundary = multipartFormDataBuilder?.generateBoundary() else { return }
        
        let multipartFormData = self.multipartFormDataBuilder?.buildMultipartFormData(texts, imageList, boundary: boundary)
        let value = "multipart/form-data;boundary=\(boundary)"
        let request = requestBuilder.buildRequest(url: serverAPI.URL, httpMethod: .patch, httpBody: multipartFormData, headerField: "Content-Type", value: value)
        
        network.load(request: request) { _, response, _ in
            guard let validResponse = response else { return }
            completionHandler(validResponse)
        }
    }
    
    func deleteItemData(serverAPI: OpenMarketServerAPI<Int>, password: String, completionHandler: @escaping (HTTPURLResponse) -> Void) {
        let passwordJSONModel = OpenMarketItemToDelete(password: password)
        
        guard let encodedPasswordResult = self.dataParser?.encodeToJSON(data: passwordJSONModel) else { return }
        
        let request = requestBuilder.buildRequest(url: serverAPI.URL, httpMethod: .delete, httpBody: try? encodedPasswordResult.get(), headerField: "Content-Type", value: "application/json")
        
        network.load(request: request) { _, response, _ in
            guard let validResponse = response else { return }
            completionHandler(validResponse)
        }
    }
    
    
}
