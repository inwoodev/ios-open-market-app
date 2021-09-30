//
//  SpyMultipartFormDataBuilder.swift
//  OpenMarketNetworkTests
//
//  Created by 황인우 on 2021/09/28.
//

import Foundation

final class SpyMultipartFormDataBuilder {
    var numberOfTextFileInFormData: Int = 0
    var numberOfImageFileInFormData: Int = 0
    var numberOfMethodDidCall: Int = 0
    
    func increaseNumberOfTextFile() {
        numberOfTextFileInFormData += 1
    }
    
    func increaseNumberOfImageFile() {
        numberOfImageFileInFormData += 1
    }
    
    func increaseNumberDidMethodCall() {
        numberOfMethodDidCall += 1
    }
}
