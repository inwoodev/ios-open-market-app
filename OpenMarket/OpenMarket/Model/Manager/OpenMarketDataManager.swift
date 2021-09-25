//
//  OpenMarketDataManager.swift
//  OpenMarket
//
//  Created by James on 2021/09/17.
//

import UIKit

final class OpenMarketDataManager {
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
    
    func getOpenMarketItemModel< U: Decodable> (serverAPI: OpenMarketServerAPI<Int>, completion: @escaping (U) -> ()) {
        
        let request = requestBuilder.buildRequest(url: serverAPI.URL, httpMethod: .get, httpBody: nil, headerField: nil, value: nil)
        
        self.network.load(request: request, completion: { [weak self] data, response, responseError in
            if let networkResponseError = responseError {
                NSLog(networkResponseError.description)
            }
            guard let validData = data,
                  let _ = response else { return }
            
            self?.dataParser?.decodeData(validData, completion: { (_ result: Result<U, DataError>) in
                switch result {
                case .failure(let dataError):
                    NSLog(dataError.description)
                case .success(let decodable):
                    return completion(decodable)
                }
            })
        })
    }
    
    func postOpenMarketItemData(serverAPI: OpenMarketServerAPI<Int>, texts: [String : Any?], imageList: [UIImage], completionHandler: @escaping (HTTPURLResponse) -> Void) {
        
        guard let boundary = multipartFormDataBuilder?.generateBoundary() else { return }
        let multipartFormData = self.multipartFormDataBuilder?.buildMultipartFormData(texts, imageList, boundary: boundary)
        let value = "multipart/form-data;boundary=\(boundary)"
        let request = requestBuilder.buildRequest(url: serverAPI.URL, httpMethod: .post, httpBody: multipartFormData, headerField: "Content-Type", value: value)
        
        // MARK: - Request Log
        
        print("------------")
        NSLog(String(describing: request.allHTTPHeaderFields))
        print("------------")
        NSLog(request.httpMethod ?? "")
        print("------------")
        print(String(decoding: request.httpBody!, as: UTF8.self))
        
        self.network.load(request: request, completion: { _, response, _ in
            
            guard let successfulResponse = response else {
                
                guard let failedResponse = response else { return }
                return completionHandler(failedResponse)
            }
            
            return completionHandler(successfulResponse)
            
        })
    }
    
    func patchOpenMarketItemData(serverAPI: OpenMarketServerAPI<Int>, texts: [String : Any?], imageList: [UIImage]?, completionHandler: @escaping (HTTPURLResponse) -> Void) {
        
        guard let boundary = multipartFormDataBuilder?.generateBoundary() else { return }
        
        let multipartFormData = self.multipartFormDataBuilder?.buildMultipartFormData(texts, imageList, boundary: boundary)
        let value = "multipart/form-data;boundary=\(boundary)"
        let request = requestBuilder.buildRequest(url: serverAPI.URL, httpMethod: .patch, httpBody: multipartFormData, headerField: "Content-Type", value: value)
        
        self.network.load(request: request, completion: { _, response, _ in
            
            guard let successfulResponse = response else {
                
                guard let failedResponse = response else { return }
                return completionHandler(failedResponse)
            }
            
            return completionHandler(successfulResponse)
            
        })
    }
    
    func deleteItemData(serverAPI: OpenMarketServerAPI<Int>, password: String, completionHandler: @escaping(HTTPURLResponse) -> Void) {
        
        let passwordJSONModel = OpenMarketItemToDelete(password: password)
        
        guard let encodedPasswordResult = self.dataParser?.encodeToJSON(data: passwordJSONModel) else { return }
        
        let request = requestBuilder.buildRequest(url: serverAPI.URL, httpMethod: .delete, httpBody: try? encodedPasswordResult.get(), headerField: "Content-Type", value: "application/json")
        
        self.network.load(request: request, completion: { _, response, _ in
            
            guard let successfulResponse = response else {
                
                guard let failedResponse = response else { return }
                return completionHandler(failedResponse)
            }
            
            return completionHandler(successfulResponse)
            
        })
    }
}
