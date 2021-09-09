//
//  TextFieldEditable.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

protocol PostingTextConvertible: PatchingTextConvertible {
    func convertRequiredTextToDictionary(_ key: OpenMarketItemToPostOrPatch, _ text: String?)
}
