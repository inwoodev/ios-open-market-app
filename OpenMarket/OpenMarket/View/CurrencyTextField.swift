//
//  CurrencyTextField.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

class CurrencyTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = OpenMarketItemToPostOrPatch.currency.placeholder.description
        self.textColor = .black
        self.font = UIFont.preferredFont(forTextStyle: .title3)
        self.tintColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
