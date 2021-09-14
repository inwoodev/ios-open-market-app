//
//  PasswordTextField.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

class PasswordTextField: UITextField {

    weak var textFieldDelegate: TextFieldConvertible?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = OpenMarketItemToPostOrPatch.password.placeholder.description
        self.textColor = .black
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isSecureTextEntry = true
        self.delegate = self
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
extension PasswordTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDelegate?.convertPasswordTextFieldToDictionary(OpenMarketItemToPostOrPatch.password, textField.text)
    }
}
