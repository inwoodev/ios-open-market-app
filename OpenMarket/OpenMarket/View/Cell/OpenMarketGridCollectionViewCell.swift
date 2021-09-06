//
//  OpenMarketGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by James on 2021/06/07.
//

import UIKit

class OpenMarketGridCollectionViewCell: UICollectionViewCell, CellDataUpdatable {
    var networkManager: NetworkManageable = NetworkManager()
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
        stackView.distribution = .fillEqually
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
            itemThumbnail.heightAnchor.constraint(equalToConstant: self.contentView.frame.height / 2),
            itemThumbnail.widthAnchor.constraint(equalToConstant: self.contentView.frame.width * 0.8),
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
        self.itemPriceLabel.attributedText = .none
        self.itemStockLabel.text = nil
        self.itemDiscountedPriceLabel.text = nil
    }
}
