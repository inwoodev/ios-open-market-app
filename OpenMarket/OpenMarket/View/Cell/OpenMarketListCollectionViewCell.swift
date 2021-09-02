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
    
    var itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
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
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textColor = .black
        return label
    }()
    
    var itemThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView.image = UIImage(named: "loadingPic")
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private let titleAndStockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let itemPricesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
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
            itemThumbnail.widthAnchor.constraint(equalToConstant: (self.contentView.frame.width) / 5),
            itemThumbnail.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            itemThumbnail.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            itemThumbnail.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 5),
            
            titleAndStockStackView.leadingAnchor.constraint(equalTo: itemThumbnail.trailingAnchor, constant: 5),
            titleAndStockStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            titleAndStockStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            
            itemPricesStackView.topAnchor.constraint(equalTo: titleAndStockStackView.bottomAnchor, constant: 5),
    
            itemPricesStackView.leadingAnchor.constraint(equalTo: itemThumbnail.trailingAnchor, constant: 5),
            itemPricesStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5)
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
