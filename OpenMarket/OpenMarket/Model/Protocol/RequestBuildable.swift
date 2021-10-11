//
//  RequestBuildable.swift
//  OpenMarket
//
//  Created by James on 2021/09/18.
//

import Foundation

protocol RequestBuildable {
    typealias headerField = String?
    typealias value = String?
    
    func buildRequest(url: URL,httpMethod: HTTPMethods, httpBody: Data?, headerField: headerField, value: value) -> URLRequest
}
