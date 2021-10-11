//
//  DiscountedPriceTextField.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

class DiscountedPriceTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = OpenMarketItemToPostOrPatch.discountedPrice.placeholder.description
        self.textColor = .black
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardType = .numberPad
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
