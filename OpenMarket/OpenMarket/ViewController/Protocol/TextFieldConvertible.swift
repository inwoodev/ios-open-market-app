//
//  TextFieldConvertible.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

protocol TextFieldConvertible: AnyObject {
    func convertTextFieldToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?)
    
    func convertPasswordTextFieldToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?)
    
    func convertOptionalTextFieldToDictionary(_ itemToPost: OpenMarketItemToPostOrPatch, _ text: String?)
}
