//
//  StockTextField.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

class StockTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = OpenMarketItemToPostOrPatch.stock.placeholder.description
        self.layer.borderWidth = 0.3
        self.textColor = .black
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = .right
        self.keyboardType = .numberPad
        self.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
