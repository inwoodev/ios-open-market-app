//
//  MultipartFormDataConverter.swift
//  OpenMarket
//
//  Created by James on 2021/09/18.
//

import Foundation

struct MultipartFormTextModel {
    let key: String
    let value: String
}

struct MultipartFormFileModel {
    let key: String
    let fileName: String
    let mimeType: MimeType
    let fileData: Data
}

struct MultipartFormDataConverter: MultipartFormDataConvertible {
    func convertTextField(textModel: MultipartFormTextModel, boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(textModel.key)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(textModel.value)\r\n"
        
        return fieldString
    }
    
    func convertFileData(fileModel: MultipartFormFileModel, using boundary: String) -> Data {
        let data = NSMutableData()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fileModel.key)\"; filename=\"\(fileModel.fileName)\"\r\n")
        data.appendString("Content-Type: \(fileModel.mimeType)\r\n\r\n")
        data.append(fileModel.fileData)
        data.appendString("\r\n")
        
        return data as Data
    }
}
