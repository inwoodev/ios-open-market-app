//
//  HTTPMethods.swift
//  OpenMarket
//
//  Created by James on 2021/05/31.
//

import Foundation

public enum HTTPMethods {
    case get
    case post
    case patch
    case delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
