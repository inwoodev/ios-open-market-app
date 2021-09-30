//
//  URLSessionDataTaskProtocol.swift
//  OpenMarket
//
//  Created by James on 2021/09/26.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
