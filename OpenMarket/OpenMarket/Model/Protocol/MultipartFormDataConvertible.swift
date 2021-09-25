//
//  MultipartFormDataConvertible.swift
//  OpenMarket
//
//  Created by James on 2021/09/18.
//

import Foundation

protocol MultipartFormDataConvertible {
    func convertTextField(textModel: MultipartFormTextModel, boundary: String) -> String
    func convertFileData(fileModel: MultipartFormFileModel, using boundary: String) -> Data
}
