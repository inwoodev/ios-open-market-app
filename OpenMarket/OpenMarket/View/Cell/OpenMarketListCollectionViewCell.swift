//
//  OpenMarketCollectionViewCell.swift
//  OpenMarket
//
//  Created by James on 2021/06/02.
//

import UIKit

class OpenMarketListCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "OpenMarketListCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUIConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Properties
    
    var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.textColor = .black
        return label
    }()
    
    var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    var itemDiscountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    var itemStockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.init(rawValue: 999), for: .horizontal)
        label.textColor = .black
        return label
    }()
    
    var itemThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleAndStockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let itemPricesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        return stackView
    }()
}
extension OpenMarketListCollectionViewCell {
    
    // MARK: - setup UI
    
    private func setUpUIConstraints() {
        
        titleAndStockStackView.addArrangedSubview(itemTitleLabel)
        titleAndStockStackView.addArrangedSubview(itemStockLabel)
        
        itemPricesStackView.addArrangedSubview(itemPriceLabel)
        itemPricesStackView.addArrangedSubview(itemDiscountedPriceLabel)
        
        self.contentView.addSubview(itemThumbnail)
        self.contentView.addSubview(titleAndStockStackView)
        self.contentView.addSubview(itemPricesStackView)
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            itemThumbnail.widthAnchor.constraint(equalTo: itemThumbnail.heightAnchor),
            itemThumbnail.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            itemThumbnail.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            itemThumbnail.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            
            titleAndStockStackView.leadingAnchor.constraint(equalTo: itemThumbnail.trailingAnchor, constant: 5),
            titleAndStockStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            titleAndStockStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            
            itemPricesStackView.topAnchor.constraint(equalTo: titleAndStockStackView.bottomAnchor, constant: 5),
    
            itemPricesStackView.leadingAnchor.constraint(equalTo: itemThumbnail.trailingAnchor, constant: 5),
            itemPricesStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -5)
])
        
    }
}
extension OpenMarketListCollectionViewCell {
    
    // MARK: - configure cell
    
    func configure(itemInformation: [OpenMarketItem], index: Int) {
        let thumbnailDownloadLink = itemInformation[index].thumbnails[0]
        
        itemTitleLabel.text = itemInformation[index].title
        itemPriceLabel.text = "\(itemInformation[index].currency)\(itemInformation[index].price)"
        self.configureDiscountedPriceLabel(itemInformation, indexPath: index)
        self.configureStockLabel(itemInformation, indexPath: index)
        itemThumbnail.applyDownloadedImage(link: thumbnailDownloadLink)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.itemThumbnail.image = nil
        self.itemTitleLabel.text = nil
        self.itemPriceLabel.attributedText = .none
        self.itemStockLabel.text = nil
        self.itemDiscountedPriceLabel.text = nil
    }
    
    func configureDiscountedPriceLabel(_ openMarketItems: [OpenMarketItem], indexPath: Int) {
        if let discountedPrice = (openMarketItems[indexPath].discountedPrice) {
            itemPriceLabel.textColor = .red
            itemPriceLabel.attributedText = itemPriceLabel.text?.strikeThrough()
            itemDiscountedPriceLabel.textColor = .black
            itemDiscountedPriceLabel.text = "\(openMarketItems[indexPath].currency) \(discountedPrice)"
        } else if openMarketItems[indexPath].discountedPrice == 0 {
            itemPriceLabel.textColor = .red
            itemPriceLabel.attributedText = itemPriceLabel.text?.strikeThrough()
            itemDiscountedPriceLabel.textColor = .black
            itemDiscountedPriceLabel.text = "무료 나눔"
        }
        
        else {
            itemPriceLabel.textColor = .black
            itemDiscountedPriceLabel.text = nil
        }
        
    }
    
    func configureStockLabel(_ openMarketItems: [OpenMarketItem], indexPath: Int) {
        if openMarketItems[indexPath].stock == 0 {
            itemStockLabel.textColor = .orange
            itemStockLabel.text = "품절"
        }
        else if openMarketItems[indexPath].stock > 999 {
            itemStockLabel.textColor = .black
            itemStockLabel.text = "잔여수량 : 999+"
        }
        else {
            itemStockLabel.textColor = .black
            itemStockLabel.text = "잔여수량 : \(openMarketItems[indexPath].stock)"
        }
    }
}
