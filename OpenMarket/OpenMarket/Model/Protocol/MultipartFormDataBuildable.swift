//
//  MultipartFormDataBuildable.swift
//  OpenMarket
//
//  Created by James on 2021/09/18.
//

import UIKit

protocol MultipartFormDataBuildable {
    func buildMultipartFormData(_ texts: [String: Any?], _ imageList: [UIImage]?, boundary: String) -> Data
    func generateBoundary() -> String
}
