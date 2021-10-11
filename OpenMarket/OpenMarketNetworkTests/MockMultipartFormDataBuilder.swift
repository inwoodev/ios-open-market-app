//
//  MockMultipartFormDataBuilder.swift
//  OpenMarketNetworkTests
//
//  Created by 황인우 on 2021/09/28.
//

import UIKit
@testable import OpenMarket

struct MockMultipartFormDataBuilder: MultipartFormDataBuildable {
    
    var spy: SpyMultipartFormDataBuilder
    
    init(spy: SpyMultipartFormDataBuilder) {
        self.spy = spy
    }
    
    func buildMultipartFormData(_ texts: [String : Any?], _ imageList: [UIImage]?, boundary: String) -> Data {
        let dummy_data = Data()
        for _ in texts {
            spy.increaseNumberOfTextFile()
        }
        
        guard let existingImageList = imageList else {
            return dummy_data
        }
        
        for _ in existingImageList {
            spy.increaseNumberOfImageFile()
        }
        spy.increaseNumberDidMethodCall()
        return dummy_data
    }
    
    func generateBoundary() -> String {
        return "boundary"
    }
    
}
