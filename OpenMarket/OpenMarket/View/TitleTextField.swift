//
//  TitleTextField.swift
//  OpenMarket
//
//  Created by James on 2021/06/18.
//

import UIKit

class TitleTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.placeholder = OpenMarketItemToPostOrPatch.title.placeholder.description
        self.textColor = .black
        self.font = UIFont.preferredFont(forTextStyle: .body)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
