//
//  CurrencyTextField.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

class CurrencyTextField: UITextField {

    weak var textFieldDelegate: PostingTextConvertible?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = OpenMarketItemToPostOrPatch.currency.placeholder.description
        self.textColor = .black
        self.font = UIFont.preferredFont(forTextStyle: .title3)
        self.tintColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
extension CurrencyTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "KRW"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.convertRequiredTextToDictionary(OpenMarketItemToPostOrPatch.currency, textField.text)
    }
}
