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
        
        urlRequest.httpMethod = HTTPMethods.get.description
        
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
    
    private func openMarketItemMultipartFormDataTask(httpMethod: HTTPMethods, url: String, texts: [String : Any?], imageList: [UIImage]?, completionHandler: @escaping(_ result: Result <HTTPURLResponse, NetworkResponseError>) -> Void) {
        
        guard let validURL = URL(string: url) else { return }
        
        var request = URLRequest(url: validURL)
        request.httpMethod = httpMethod.description
        request.httpBody = buildMultipartFormData(texts, imageList)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // MARK: - Request Log
        
        print("------------")
        NSLog(String(describing: request.allHTTPHeaderFields))
        print("------------")
        NSLog(request.httpMethod ?? "")
        print("------------")
        print(String(decoding: request.httpBody!, as: UTF8.self))
        
        dataTask = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog(error.localizedDescription)
                completionHandler(.failure(NetworkResponseError.failed))
            }
            
            guard let successfulResponse = response as? HTTPURLResponse,
                  (200...299).contains(successfulResponse.statusCode) else {
                if let failedResponse = response as? HTTPURLResponse {
                    
                    // MARK: - failure Response Log
                    
                    NSLog((String(describing: failedResponse.statusCode)))
                    completionHandler(.success(failedResponse))
                }
                return
                
            }
            
            if let mimeType = successfulResponse.mimeType,
               mimeType == "application/json" {
                
                // MARK: - successful Response Log
                
                NSLog(String(successfulResponse.statusCode))
                completionHandler(.success(successfulResponse))
            }
        }
        dataTask?.resume()
    }
    
    func postSingleItem(url: String, texts: [String : Any?], imageList: [UIImage], completionHandler: @escaping (HTTPURLResponse) -> Void) {
        openMarketItemMultipartFormDataTask(httpMethod: .post, url: url, texts: texts, imageList: imageList) { result in
            switch result {
            case .success(let response):
                NSLog("item post succeeded with response code: \(response.statusCode)")
                completionHandler(response)
            
            case .failure(let networkError):
                NSLog(networkError.description)
            }
        }
    }
    
    func patchSingleItem(url: String, texts: [String : Any?], images: [UIImage]?, completionHandler: @escaping (HTTPURLResponse) -> Void) {
        openMarketItemMultipartFormDataTask(httpMethod: .patch, url: url, texts: texts, imageList: images, completionHandler: { result in
            switch result {
            case .success(let response):
                NSLog("item patch succeeded with response code: \(response.statusCode)")
                completionHandler(response)
            case .failure(let networkError):
                NSLog(networkError.description)
            }
        })
    }
    
    func getSingleItem(itemURL: String, id: Int, completion: @escaping (_ result: Result <OpenMarketItemToGet, NetworkResponseError>) -> Void) {
        
        guard let url = URL(string: "\(itemURL)/\(id)") else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethods.get.description
        
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
    
    func deleteSingleItem(url: String, id: Int, password: String, completionHandler: @escaping(HTTPURLResponse) -> Void) {
        guard let validURL = URL(string: "\(url)\(id)") else { return }
        
        var request = URLRequest(url: validURL)
        request.httpMethod = HTTPMethods.delete.description
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        
        let passwordJSONModel = OpenMarketItemToDelete(password: password)
        
        guard let encodedPassword = try? JSONEncoder().encode(passwordJSONModel) else {
            NSLog(DataError.encoding.description)
            return
        }
        request.httpBody = encodedPassword
        
        NSLog(String(describing: request.allHTTPHeaderFields))
        print("----------")
        print(String(decoding: request.httpBody!, as: UTF8.self))
        print("----------")
        
        dataTask = urlSession.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                NSLog(error.localizedDescription)
                return
            }
            
            guard let successfulResponse = response as? HTTPURLResponse else {
                if let failedResponse = response as? HTTPURLResponse {
                    completionHandler(failedResponse)
                }
                return
            }
            completionHandler(successfulResponse)
        })
        dataTask?.resume()
    }
}
