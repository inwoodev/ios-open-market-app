//
//  OpenMarketCollectionViewCell.swift
//  OpenMarket
//
//  Created by James on 2021/06/02.
//

import UIKit

class OpenMarketListCollectionViewCell: UICollectionViewCell, CellDataUpdatable {
    var networkManager: NetworkManageable = NetworkManager()
    static let identifier: String = "OpenMarketListCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUIConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Properties
    
    lazy var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.textColor = .black
        return label
    }()
    
    lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    lazy var itemDiscountedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    lazy var itemStockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textColor = .black
        return label
    }()
    
    lazy var itemThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView.image = UIImage(named: "loadingPic")
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    lazy var titleAndStockLabels: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [itemTitleLabel, itemStockLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
}
extension OpenMarketListCollectionViewCell {
    
    // MARK: - setup UI
    
    private func setUpUIConstraints() {
        
        [ titleAndStockLabels, itemPriceLabel, itemDiscountedPriceLabel, itemThumbnail, ].forEach {
            contentView.addSubview($0)
        }
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            itemThumbnail.heightAnchor.constraint(equalToConstant: self.contentView.frame.height),
            itemThumbnail.widthAnchor.constraint(lessThanOrEqualToConstant: (self.contentView.frame.width) / 5),
            itemThumbnail.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            itemThumbnail.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            itemThumbnail.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),

            titleAndStockLabels.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            titleAndStockLabels.leadingAnchor.constraint(equalTo: itemThumbnail.trailingAnchor, constant: 5),
            titleAndStockLabels.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            
            itemPriceLabel.topAnchor.constraint(equalTo: titleAndStockLabels.bottomAnchor, constant: 5),
            itemPriceLabel.leadingAnchor.constraint(equalTo: itemThumbnail.trailingAnchor, constant: 5),
            itemPriceLabel.bottomAnchor.constraint(equalTo: itemThumbnail.bottomAnchor),
            
            itemDiscountedPriceLabel.topAnchor.constraint(equalTo: itemPriceLabel.topAnchor),
            itemDiscountedPriceLabel.leadingAnchor.constraint(equalTo: itemPriceLabel.trailingAnchor, constant: 5),
            itemDiscountedPriceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            itemDiscountedPriceLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -7),
        ])
        
    }
}
extension OpenMarketListCollectionViewCell {
    
    // MARK: - configure cell
    
    func configure(_ openMarketItems: [OpenMarketItem], indexPath: Int) {
        itemTitleLabel.text = openMarketItems[indexPath].title
        itemPriceLabel.text = "\(openMarketItems[indexPath].currency) \(openMarketItems[indexPath].price)"
        itemStockLabel.text = String(openMarketItems[indexPath].stock)
        
        configureDiscountedPriceLabel(openMarketItems, indexPath: indexPath)
        configureStockLabel(openMarketItems, indexPath: indexPath)
        
        DispatchQueue.global().async { [weak self] in
            self?.networkManager.dataTask = self?.applyRequestedImage(openMarketItems, indexPath: indexPath)
            self?.networkManager.dataTask?.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.networkManager.dataTask?.cancel()
        self.itemThumbnail.image = UIImage(named: "loadingPic")
        self.itemTitleLabel.text = nil
        self.itemPriceLabel.text = nil
        self.itemStockLabel.text = nil
        self.itemDiscountedPriceLabel.text = nil
    }
}
