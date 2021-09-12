//
//  DetailedItemTitleTextView.swift
//  OpenMarket
//
//  Created by James on 2021/09/06.
//

import UIKit

final class DetailedItemTitleTextView: UITextView {
    
    weak var titleViewDelegate: PatchingTextConvertible?
    
    private let defaultMessage: String = "상품 이름"
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.adjustsFontForContentSizeCategory = true
        self.font = UIFont.preferredFont(forTextStyle: .title3)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.delegate = self
        self.isScrollEnabled = false
        self.isEditable = false
    }
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
}

extension DetailedItemTitleTextView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = defaultMessage
            textView.textColor = .lightGray
        }
        
        guard textView.text != defaultMessage,
              textView.text.isEmpty else { return }
        
        titleViewDelegate?.convertOptionalTextToDictionary(OpenMarketItemToPostOrPatch.title, textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == defaultMessage {
            textView.text = nil
        }
    }
}
