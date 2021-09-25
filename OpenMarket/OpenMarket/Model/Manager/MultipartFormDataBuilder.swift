//
//  MultipartFormDataBuilder.swift
//  OpenMarket
//
//  Created by James on 2021/09/18.
//

import UIKit

struct MultipartFormDataBuilder: MultipartFormDataBuildable {
    
    private let multipartFormDataConverter: MultipartFormDataConvertible
    
    init(multipartFormDataConverter: MultipartFormDataConvertible) {
        self.multipartFormDataConverter = multipartFormDataConverter
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    
    func buildMultipartFormData(_ texts: [String: Any?], _ imageList: [UIImage]?, boundary: String) -> Data {
        let httpBody = NSMutableData()
        
        for (key, value) in texts {
            if let validValue = value {
                let convertedValue = String(describing: validValue)
                httpBody.appendString(multipartFormDataConverter.convertTextField(textModel: MultipartFormTextModel(key: key, value: convertedValue), boundary: boundary))
            }
            
        }
        
        guard let images = imageList else {
            
            NSLog("httpbody without images")
            httpBody.appendString("--\(boundary)--")
            return httpBody as Data
            
        }
        
        for image in images {
            
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                return Data()
                
            }
            
            let convertedImage = imageData.base64EncodedData()
            guard let stringData = String(bytes: convertedImage, encoding: .utf8),
                  let finalData = Data(base64Encoded: stringData) else {
                return Data()
            }
            httpBody.append(multipartFormDataConverter.convertFileData(fileModel: MultipartFormFileModel(key: OpenMarketItemToPostOrPatch.images.key, fileName: "\(Date().timeIntervalSince1970)_photo.jpeg", mimeType: .jpeg, fileData: finalData), using: boundary))

        }
        
        httpBody.appendString("--\(boundary)--")
        return httpBody as Data
    }
}
