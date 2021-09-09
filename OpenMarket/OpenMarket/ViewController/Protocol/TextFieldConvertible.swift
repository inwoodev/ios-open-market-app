//
//  TextFieldEditable.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

protocol PostingTextConvertible: AnyObject {
    func convertTextToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?)
    
    func convertPasswordTextToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?)
    
    func convertOptionalTextToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?)
}
