//
//  Network.swift
//  OpenMarket
//
//  Created by James on 2021/09/17.
//

import Foundation

final class Network: Networkable {
    
    let urlSession: URLSessionProtocol
    var dataTask: URLSessionDataTask?
    
    init(urlSession: URLSessionProtocol = URLSession.shared, dataTask: URLSessionDataTask? = nil) {
        self.urlSession = urlSession
        self.dataTask = dataTask
    }
    
    func load(request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, NetworkResponseError?) -> ()) {
        
        dataTask = urlSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                NSLog(error.localizedDescription)
                completion(nil, response as? HTTPURLResponse, error as? NetworkResponseError)
            }
            guard let successFulResponse = response as? HTTPURLResponse,
                  let completedData = data
                  else {
                
                guard let failedResponse = response as? HTTPURLResponse else {
                    return }
                
                // MARK: - Failed Response Status Code
                
                NSLog(String(failedResponse.statusCode))
                return completion(nil, failedResponse, NetworkResponseError.failed)
                
                
            }
            
            // MARK: - SuccessfulResponse Status Code
            
            NSLog(String(successFulResponse.statusCode))
            
            completion(completedData, successFulResponse, nil)
            
        }
        dataTask?.resume()
    }
    
    func cancel() {
        dataTask?.cancel()
    }
}
