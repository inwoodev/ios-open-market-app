//
//  PasswordTextField.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

class PasswordTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = OpenMarketItemToPostOrPatch.password.placeholder.description
        self.textColor = .black
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isSecureTextEntry = true
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
