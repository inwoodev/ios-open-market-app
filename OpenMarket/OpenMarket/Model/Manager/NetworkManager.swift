//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by James on 2021/05/31.
//

import UIKit

final class NetworkManager: NetworkManageable {
    var dataTask: URLSessionDataTask?
    var boundary = "Boundary-\(UUID().uuidString)"
    var isReadyToPaginate: Bool = false
    let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func getItemList(page: Int, loadingFinished: Bool = false, completionHandler: @escaping (_ result: Result <OpenMarketItemList, Error>) -> Void) {
        
        if loadingFinished {
            isReadyToPaginate = false
        }
        
        guard let url = URL(string: "\(OpenMarketAPI.urlForItemList)\(page)") else {
            return completionHandler(.failure(NetworkResponseError.badRequest))
        }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethods.get.rawValue
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let dataError = error {
                completionHandler(.failure(NetworkResponseError.noData))
                print(dataError.localizedDescription)
            }
            if let urlResponse = response as? HTTPURLResponse {
                let urlResponseResult = self.handleNetworkResponseError(urlResponse)
                switch urlResponseResult {
                case .failure(let errorDescription):
                    print(errorDescription)
                    return completionHandler(.failure(NetworkResponseError.badRequest))
                case .success:
                    guard let itemListData = data else {
                        return completionHandler(.failure(NetworkResponseError.noData))
                    }
                    if let itemList = try? JSONDecoder().decode(OpenMarketItemList.self, from: itemListData) {
                        completionHandler(.success(itemList))
                        if loadingFinished {
                            self.isReadyToPaginate = true
                        }
                        
                    } else {
                        completionHandler(.failure(DataError.decoding))
                    }
                }
            }
        }.resume()
    }
    
    private func openMarketItemDataTask(url: String, texts: [String : Any?], imageList: [UIImage], completionHandler: @escaping (Bool) -> Void) -> URLSessionDataTask? {
        
        guard let validURL = URL(string: url) else {
            return nil
            
        }
        
        var request = URLRequest(url: validURL)
        request.httpMethod = HTTPMethods.post.rawValue
        request.httpBody = buildMultipartFormData(texts, imageList)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // MARK: - Request Log
        
        print("------------")
        print(request.allHTTPHeaderFields)
        print("------------")
        print(request.httpMethod)
        print("------------")
        print(String(decoding: request.httpBody!, as: UTF8.self))
        
        return urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(false)
            }
            
            guard let successfulResponse = response as? HTTPURLResponse,
                  (200...299).contains(successfulResponse.statusCode) else {
                let failedResponse = response as? HTTPURLResponse
                
                // MARK: - Response Log
                
                print(failedResponse?.statusCode)
                
                completionHandler(false)
                return
            }
            
            if let mimeType = successfulResponse.mimeType,
               mimeType == "multipart/form-data",
               let _ = data {
                completionHandler(true)
            }
        }
    }
    
    func postSingleItem(url: String, texts: [String : Any?], imageList: [UIImage], completionHandler: @escaping (URLSessionDataTask) -> Void) {
        dataTask = openMarketItemDataTask(url: OpenMarketAPI.urlForSingleItem.description, texts: texts, imageList: imageList) { bool in
            switch bool {
            case true:
                print("data can be sent to server")
                
            case false:
                print("data has unknown error, and thus cannot be sent to server")
            }
        }
        dataTask?.resume()
    }
    
    func getSingleItem(itemURL: String, id: Int, completion: @escaping (_ result: Result <OpenMarketItemToGet, NetworkResponseError>) -> Void) {
        
        guard let url = URL(string: "\(itemURL)/\(id)") else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethods.get.rawValue
        
        dataTask = urlSession.dataTask(with: request) { data, response, error in
            if let networkError = error {
                completion(.failure(NetworkResponseError.noData))
                NSLog(networkError.localizedDescription)
            }
            
            if let httpURLResponse = response as? HTTPURLResponse {
                let result = self.handleNetworkResponseError(httpURLResponse)
                switch result {
                case .success:
                    guard let completeData = data,
                          let singleItem = try? JSONDecoder().decode(OpenMarketItemToGet.self, from: completeData) else {
                        return completion(.failure(NetworkResponseError.noData))
                    }
                    completion(.success(singleItem))
                case .failure(let description):
                    NSLog(description)
                    completion(.failure(NetworkResponseError.badRequest))
                }
            }
        }
        dataTask?.resume()
        
    }
}
