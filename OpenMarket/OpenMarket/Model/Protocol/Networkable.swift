//
//  Networkable.swift
//  OpenMarket
//
//  Created by James on 2021/09/18.
//

import Foundation

protocol Networkable: AnyObject {
    var urlSession: URLSessionProtocol { get }
    var dataTask: URLSessionDataTask? { get set }
    
    func load(request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, NetworkResponseError?) -> ())
    func cancel()
}
