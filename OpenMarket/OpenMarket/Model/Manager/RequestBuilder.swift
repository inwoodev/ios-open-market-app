//
//  RequestBuilder.swift
//  OpenMarket
//
//  Created by James on 2021/09/18.
//

import Foundation

struct RequestBuilder: RequestBuildable {
    typealias headerField = String?
    typealias value = String?

    
    func buildRequest(url: URL,httpMethod: HTTPMethods, httpBody: Data?, headerField: headerField, value: value) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.description
        request.httpBody = httpBody
        guard let validHeaderField = headerField else {
            return request
        }
        request.setValue(value, forHTTPHeaderField: validHeaderField)
        
        return request
        
    }
}
