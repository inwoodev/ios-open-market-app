//
//  DiscountedPriceTextField.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

class DiscountedPriceTextField: UITextField {

    weak var textFieldDelegate: PostingTextConvertible?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = OpenMarketItemToPostOrPatch.discountedPrice.placeholder.description
        self.textColor = .black
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardType = .numberPad
        self.delegate = self
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
extension DiscountedPriceTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.convertOptionalTextToDictionary(OpenMarketItemToPostOrPatch.discountedPrice, textField.text)
    }
}
