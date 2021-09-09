//
//  PatchingTextConvertible.swift
//  OpenMarket
//
//  Created by James on 2021/09/07.
//

import UIKit

protocol PatchingTextConvertible: AnyObject {
    func convertPasswordTextToDictionary(_ key: OpenMarketItemToPostOrPatch, _ text: String?)
    
    func convertOptionalTextToDictionary(_ key: OpenMarketItemToPostOrPatch, _ text: String?)

}
