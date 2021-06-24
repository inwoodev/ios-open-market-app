//
//  CellDataUpdatable.swift
//  OpenMarket
//
//  Created by James on 2021/06/07.
//

import Foundation
import UIKit

protocol CellDataUpdatable: AnyObject {
    var itemTitleLabel: UILabel { get }
    var itemPriceLabel: UILabel { get }
    var itemStockLabel: UILabel { get }
    var itemThumbnail: UIImageView { get }
    var itemDiscountedPriceLabel: UILabel { get }
    var networkManager: NetworkManageable { get }
}
extension CellDataUpdatable {
    
    func configureDiscountedPriceLabel(_ openMarketItems: [OpenMarketItem], indexPath: Int) {
        if let discountedPrice = (openMarketItems[indexPath].discountedPrice) {
            itemPriceLabel.textColor = .red
            itemPriceLabel.attributedText = itemPriceLabel.text?.strikeThrough()
            itemDiscountedPriceLabel.text = "\(openMarketItems[indexPath].currency) \(discountedPrice)"
        } else {
            itemDiscountedPriceLabel.text = nil
        }
        
    }
    
    func configureStockLabel(_ openMarketItems: [OpenMarketItem], indexPath: Int) {
        if openMarketItems[indexPath].stock == 0 {
            itemStockLabel.textColor = .orange
            itemStockLabel.text = "품절"
        } else {
            itemStockLabel.text = "잔여수량 : \(openMarketItems[indexPath].stock)"
        }
    }
    
    func applyRequestedImage(_ openMarketItems: [OpenMarketItem], indexPath: Int) -> URLSessionDataTask? {
        guard let url = URL(string: openMarketItems[indexPath].thumbnails[0]) else { return nil
        }
        return networkManager.imageDownloadDataTask(url: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.itemThumbnail.image = image
            }
        }
    }
}
