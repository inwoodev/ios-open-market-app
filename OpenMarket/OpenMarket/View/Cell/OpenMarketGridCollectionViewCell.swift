//
//  OpenMarketGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by James on 2021/06/07.
//

import UIKit

class OpenMarketGridCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "OpenMarketGridCollectionViewCell"
    
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
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.textColor = .black
        return label
    }()
    
    var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    var itemDiscountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    var itemStockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.textColor = .black
        return label
    }()
    
    var itemThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView.image = UIImage(named: "loadingPic")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let itemPricesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let itemInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
}
extension OpenMarketGridCollectionViewCell {
    
    // MARK: - setup UI Constraints
    
    private func setUpUIConstraints() {
        itemPricesStackView.addArrangedSubview(itemPriceLabel)
        itemPricesStackView.addArrangedSubview(itemDiscountedPriceLabel)
        
        itemInformationStackView.addArrangedSubview(itemTitleLabel)
        itemInformationStackView.addArrangedSubview(itemPricesStackView)
        itemInformationStackView.addArrangedSubview(itemStockLabel)
        
        self.contentView.addSubview(itemThumbnail)
        self.contentView.addSubview(itemInformationStackView)
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            itemThumbnail.widthAnchor.constraint(equalTo: itemThumbnail.heightAnchor),
            itemThumbnail.heightAnchor.constraint(equalToConstant: self.contentView.frame.height / 2),
            itemThumbnail.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            itemThumbnail.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            
            itemInformationStackView.topAnchor.constraint(equalTo: itemThumbnail.bottomAnchor, constant: 5),
            itemInformationStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            itemInformationStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            itemInformationStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
    }
}
extension OpenMarketGridCollectionViewCell {
    
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
        self.itemThumbnail.image = UIImage(named: "loadingPic")
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
